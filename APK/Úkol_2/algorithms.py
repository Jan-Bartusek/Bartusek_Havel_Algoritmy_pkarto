import math
import numpy as np
import numpy.linalg as np2
from PyQt6.QtCore import QPointF, QLineF
from PyQt6.QtGui import QPolygonF, QTransform

class Algorithms:
    
    def __init__(self):
        pass
    
    def get2VectorsAngle(self, p1: QPointF, p2: QPointF, p3: QPointF, p4: QPointF):
        # Calculate the angle between two 2D vectors: vector u (p1->p2) and vector v (p3->p4)
        ux = p2.x() - p1.x()    
        uy = p2.y() - p1.y()
        
        vx = p4.x() - p3.x()
        vy = p4.y() - p3.y()    
        
        # Calculate the dot product (scalar product) of vectors u and v
        dot = ux * vx + uy * vy
        
        # Calculate the Euclidean norms (magnitudes) of both vectors
        nu = math.sqrt(ux**2 + uy**2)
        nv = math.sqrt(vx**2 + vy**2)
        
        # Prevent division by zero exception which occurs when identical points are passed 
        if nu == 0 or nv == 0:
            return 0.0
        
        # Calculate the cosine of the angle using the dot product formula: cos(theta) = (u * v) / (|u| * |v|)
        arg = dot / (nu * nv)
        
        # Clamp the argument to the strict [-1.0, 1.0] interval to prevent math domain errors 
        # caused by minor floating-point inaccuracies
        arg = max(-1.0, min(1.0, arg)) 
        
        # Return the arc cosine to get the actual angle in radians
        return math.acos(arg)
    
    def createCH(self, pol: QPolygonF):
        # Create Convex Hull using the Jarvis March (Gift Wrapping) algorithm. Time complexity: O(nh)
        ch = QPolygonF()
        
        # Step 1: Find the absolute lowest point (pivot) which is guaranteed to be on the convex hull
        q = min(pol, key=lambda k: k.y())

        # Step 2: Establish the initial reference vector. 
        pj = q
        pj1 = QPointF(q.x() - 1.0, q.y()) 
        
        ch.append(pj)
        
        # Step 3: Iteratively find the next point forming the widest angle (right-most turn)
        while True:
            omega_max = 0
            index_max = -1
            
            # Evaluate the angle against all other points in the polygon
            for i in range(len(pol)):
                if pj != pol[i]:
                    # Calculate angle between the current hull edge and the candidate point
                    omega = self.get2VectorsAngle(pj, pj1, pj, pol[i])
            
                    # Keep track of the point that creates the maximum angle
                    if omega > omega_max:
                        omega_max = omega
                        index_max = i
                    
            # Add the winning point to the convex hull
            ch.append(pol[index_max])
            
            # Shift the reference points for the next iteration
            pj1 = pj
            pj = pol[index_max]
            
            # Stopping condition: If we wrap all the way around back to the starting pivot, we are done
            if pj == q:
                break
            
        return ch
    
    def getGrahamAngleAndDist(self, p: QPointF, pivot: QPointF) -> tuple:
        # Helper function for Graham Scan sorting mechanism. 
        # Calculates the polar angle and Euclidean distance relative to the pivot point.
        dx = p.x() - pivot.x()
        dy = p.y() - pivot.y()
        angle = math.atan2(dy, dx)
        dist = math.hypot(dx, dy)
        return angle, dist
        
    def getOrientation(self, p1: QPointF, p2: QPointF, p3: QPointF) -> float:
        # Calculates the Z-component of the 2D cross product of vectors (p1->p2) and (p1->p3).
        # Positive result = Left turn, Negative result = Right turn, Zero = Collinear.
        return (p2.x() - p1.x()) * (p3.y() - p1.y()) - (p2.y() - p1.y()) * (p3.x() - p1.x())

    def createCHGrahamScan(self, pol: QPolygonF) -> QPolygonF:
        # Create Convex Hull using the Graham Scan algorithm. Time complexity: O(n log n).
        # Highly efficient for complex building geometries.
        if len(pol) < 3:
            return pol
            
        # Step 1: Find the lowest point (pivot). If tied, pick the left-most one.
        pivot = min(pol, key=lambda p: (p.y(), p.x()))
        
        # Step 2: Extract all unique points to avoid sorting errors and filter out the pivot itself
        points = []
        for p in pol:
            if p != pivot:
                if not any(p.x() == pt.x() and p.y() == pt.y() for pt in points):
                    points.append(p)
                
        # Step 3: Sort remaining points strictly by their polar angle with the pivot.
        points.sort(key=lambda p: self.getGrahamAngleAndDist(p, pivot))
        
        # Step 4: Initialize the state stack with our starting pivot
        stack = [pivot]
        
        # Step 5: Process points. Maintain convexity by popping points that create a right (concave) turn
        for p in points:
            while len(stack) > 1:
                p1 = stack[-2]
                p2 = stack[-1]
                p3 = p
                
                # Check the orientation of the last three points
                cp = self.getOrientation(p1, p2, p3)
                
                # If cross product <= 0, the segment forms a concave dent or straight line. 
                # Pop the middle point to maintain strict convexity.
                if cp <= 0:
                    stack.pop()
                else:
                    break
            stack.append(p)
            
        # Step 6: Convert the optimized stack back into a QPolygonF structure
        ch = QPolygonF()
        for p in stack:
            ch.append(p)
            
        return ch

    def createMMB(self, pol: QPolygonF):
        # Create an Axis-Aligned Minimum Bounding Box (AABB)
        # Finds extreme coordinates (min/max X and Y) to form a strict orthogonal rectangle
        p_xmin = min(pol, key=lambda k: k.x())
        p_xmax = max(pol, key=lambda k: k.x())
        p_ymin = min(pol, key=lambda k: k.y())
        p_ymax = max(pol, key=lambda k: k.y())
        
        v1 = QPointF(p_xmin.x(), p_ymin.y())
        v2 = QPointF(p_xmax.x(), p_ymin.y())
        v3 = QPointF(p_xmax.x(), p_ymax.y())
        v4 = QPointF(p_xmin.x(), p_ymax.y())
        
        mmb = QPolygonF([v1, v2, v3, v4])
        
        # Calculate the area of this orthogonal bounding box
        area = (v2.x() - v1.x()) * (v3.y() - v2.y())
        
        return mmb, area
      
    def rotatePolygon(self, pol: QPolygonF, sig: float):
        # Applies a standard 2D rotation matrix transformation to every vertex of the polygon
        pol_rot = QPolygonF()
        for i in range(len(pol)):
            x_rot = pol[i].x() * math.cos(sig) - pol[i].y() * math.sin(sig)
            y_rot = pol[i].x() * math.sin(sig) + pol[i].y() * math.cos(sig)
            pol_rot.append(QPointF(x_rot, y_rot))
        return pol_rot
    
    def createMBR(self, building: QPolygonF):
        # Calculates the Minimum Area Enclosing Rectangle (MAER)
        sigma_min = 0
        
        # Step 1: Pre-compute the convex hull to drastically reduce the number of edges to evaluate
        ch = self.createCHGrahamScan(building)
        
        # Initialize with an unrotated Axis-Aligned Bounding Box
        mmb_min, area_min = self.createMMB(ch)
        
        # Step 2: Iterate through every edge of the convex hull
        n = len(ch)
        for i in range(n):
            dx = ch[(i+1)%n].x() - ch[i].x()
            dy = ch[(i+1)%n].y() - ch[i].y()
            
            # Find the orientation angle of the current edge
            sigma = math.atan2(dy, dx)
            
            # Rotate the entire hull to align this specific edge horizontally with the X-axis
            ch_r = self.rotatePolygon(ch, -sigma)
            
            # Calculate the bounding box for this alignment
            mmb, area = self.createMMB(ch_r)
            
            # If this alignment yields a smaller area, save it as the new minimum
            if area < area_min:    
                area_min = area
                mmb_min = mmb
                sigma_min = sigma
                
        # Step 3: Rotate the smallest found box back to its original geographic orientation
        return self.rotatePolygon(mmb_min, sigma_min) 
    
    def getArea(self, pol: QPolygonF):
        # Computes the true area of a polygon using the Shoelace formula (Surveyor's formula)
        area = 0
        n = len(pol)
        for i in range(n):
            # area += x_i * (y_{i+1} - y_{i-1})
            area += pol[i].x() * (pol[(i + 1) % n].y() - pol[(i - 1 + n) % n].y())
        return abs(area) / 2    
    
    def getPerimeter(self, pol: QPolygonF) -> float:
        # Calculate the total perimeter of a polygon
        perimeter = 0.0
        n = len(pol)
        for i in range(n):
            p1 = pol[i]
            p2 = pol[(i + 1) % n]
            
            dx = p1.x() - p2.x()
            dy = p1.y() - p2.y()
            perimeter += math.hypot(dx, dy)
            
        return perimeter
        
    def resizeRectangle(self, building: QPolygonF, mbr: QPolygonF):
        A = self.getArea(mbr)
        
        # Prevent division by zero if the geometry collapses to a straight line (area = 0)
        if A == 0:
            return mbr
            
        Ab = self.getArea(building)
        
        # Calculate the area ratio 'k'
        k = Ab / A
        
        # Compute the geometric center (centroid) of the rectangle
        x_c = (mbr[0].x() + mbr[1].x() + mbr[2].x() + mbr[3].x()) / 4
        y_c = (mbr[0].y() + mbr[1].y() + mbr[2].y() + mbr[3].y()) / 4
        
        mbr_res = QPolygonF()
        for i in range(4):
            # Create a vector from the centroid to the rectangle's vertex
            v_x = mbr[i].x() - x_c
            v_y = mbr[i].y() - y_c 
            
            # Scale the vector. Since area scales quadratically (A = w*h), linear dimensions 
            # must be scaled by the square root of the area ratio (sqrt(k)).
            v_x_res = v_x * math.sqrt(k)
            v_y_res = v_y * math.sqrt(k)
            
            # Translate the scaled vector back to global coordinates
            p_x = v_x_res + x_c  
            p_y = v_y_res + y_c 
            
            mbr_res.append(QPointF(p_x, p_y))
            
        return mbr_res
    
    def simplifyBuildingMBR(self, building: QPolygonF):
        # Generalize a building using Minimum Area Enclosing Rectangle + Area Preservation
        mbr = self.createMBR(building)
        return self.resizeRectangle(building, mbr)
    
    def simplifyBuildingPCA(self, building: QPolygonF):
        # Generalize using Principal Component Analysis (PCA)
        # Finds the direction of maximum spatial variance of the building's vertices
        X, Y = [], []
        
        # Extract X and Y coordinates into statistical arrays
        for p in building:
            X.append(p.x())
            Y.append(p.y())
            
        A = np.array([X, Y])
        
        # Compute the 2x2 Covariance Matrix to understand coordinate correlation
        C = np.cov(A)
        
        # Perform Singular Value Decomposition (SVD) to extract eigenvectors and eigenvalues
        [U, S, V] = np2.svd(C)
        
        # The first principal component (direction of highest variance) is derived from the first eigenvector V[0]
        sigma = math.atan2(V[0][1], V[0][0])
        
        # Align the building along the principal component, calculate AABB, rotate back, and preserve area
        build_rot = self.rotatePolygon(building, -sigma)
        mmb, area = self.createMMB(build_rot)
        mbr = self.rotatePolygon(mmb, sigma)
        
        return self.resizeRectangle(building, mbr)
    
    def simplifyBuildingLongestEdge(self, building: QPolygonF) -> QPolygonF:
        # Generalization method assuming the building's main orientation aligns with its longest physical wall
        max_length = 0.0
        longest_line = QLineF()
        
        # Iterate over all walls to find the absolute longest segment
        n = len(building)
        for i in range(n):
            p1 = building[i]
            p2 = building[(i + 1) % n] 
            
            line = QLineF(p1, p2)
            if line.length() > max_length:
                max_length = line.length()
                longest_line = line
                
        # Extract the geographical angle of the longest edge
        angle = longest_line.angle()
        
        # Use QTransform for highly optimized internal matrix rotations
        transform = QTransform()
        transform.rotate(angle)
        rotated_building = transform.map(building)
        
        # Extract the Axis-Aligned bounding box from the rotated state
        bbox = rotated_building.boundingRect()
        bbox_poly = QPolygonF([
            bbox.topLeft(), bbox.topRight(),
            bbox.bottomRight(), bbox.bottomLeft()
        ])
        
        # Revert rotation and scale to preserve original area
        inv_transform = QTransform()
        inv_transform.rotate(-angle)
        final_rect = inv_transform.map(bbox_poly)
        
        return self.resizeRectangle(building, final_rect)
        
    def simplifyBuildingWallAverage(self, building: QPolygonF) -> QPolygonF:
        # Generalization using the Weighted Wall Average method.
        # addresses the problem of irregular orthogonal buildings (L-shapes, U-shapes).
        n = len(building)
        sum_x = 0.0
        sum_y = 0.0
        
        for i in range(n):
            p1 = building[i]
            p2 = building[(i + 1) % n]
            line = QLineF(p1, p2)
            length = line.length()
            
            # Skip invalid zero-length artifacts
            if length == 0:
                continue
                
            angle_rad = math.radians(line.angle())
            
            
            # Multiplying by 4 maps all these orthogonal angles to 360 (0) degrees.
            sum_x += length * math.cos(4 * angle_rad)
            sum_y += length * math.sin(4 * angle_rad)
            
        # Calculate the average vector angle and divide by 4 to revert the mathematical trick
        avg_angle_rad = math.atan2(sum_y, sum_x) / 4.0
        avg_angle_deg = math.degrees(avg_angle_rad)
        
        # Apply the averaged orientation
        transform = QTransform()
        transform.rotate(avg_angle_deg)
        rotated_building = transform.map(building)
        
        # Generate bounding box in the averaged orientation
        bbox = rotated_building.boundingRect()
        bbox_poly = QPolygonF([
            bbox.topLeft(), bbox.topRight(),
            bbox.bottomRight(), bbox.bottomLeft()
        ])
        
        # Rotate back to geographic space and adjust final area
        inv_transform = QTransform()
        inv_transform.rotate(-avg_angle_deg)
        final_rect = inv_transform.map(bbox_poly)
        
        return self.resizeRectangle(building, final_rect)
    
    def simplifyBuildingWeightedBisector(self, building: QPolygonF) -> QPolygonF:
        # Generalization using the Weighted Bisector method.
        # Identifies the dominant structural axis of complex/irregular shapes.
        n = len(building)
        sum_x = 0.0
        sum_y = 0.0
        
        for i in range(n):
            p1 = building[i]
            p2 = building[(i + 1) % n]
            line = QLineF(p1, p2)
            length = line.length()
            
            if length == 0:
                continue
                
            angle_rad = math.radians(line.angle())
            
        
            # prioritizing the overall longitudinal symmetry of the polygon.
            sum_x += length * math.cos(2 * angle_rad)
            sum_y += length * math.sin(2 * angle_rad)
            
        # Calculate the final axial angle and divide by 2 to revert the multiplier
        avg_angle_rad = math.atan2(sum_y, sum_x) / 2.0
        avg_angle_deg = math.degrees(avg_angle_rad)
        
        # Apply the bisector orientation
        transform = QTransform()
        transform.rotate(avg_angle_deg)
        rotated_building = transform.map(building)
        
        # Generate bounding box
        bbox = rotated_building.boundingRect()
        bbox_poly = QPolygonF([
            bbox.topLeft(), bbox.topRight(),
            bbox.bottomRight(), bbox.bottomLeft()
        ])
        
        # Rotate back to geographic coordinates and enforce area preservation
        inv_transform = QTransform()
        inv_transform.rotate(-avg_angle_deg)
        final_rect = inv_transform.map(bbox_poly)
        
        return self.resizeRectangle(building, final_rect)