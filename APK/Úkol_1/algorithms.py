import math
from PyQt6.QtCore import *
from PyQt6.QtGui import *
from PyQt6.QtWidgets import *

class Algorithms:
    
    def getPointPolygonPositionRC(self, q: QPointF, complex_pol: list[QPolygonF]):
        # Analyze using Ray Crossing
        k = 0  
        tolerance = 5.0
        
        # Loop through outer boundary and all holes
        for ring in complex_pol:
            if ring.isEmpty():
                continue
                
            n = len(ring) 
            for i in range(n):
                xi = ring[i].x() - q.x()
                yi = ring[i].y() - q.y()
                
                xi1 = ring[(i+1)%n].x() - q.x()
                yi1 = ring[(i+1)%n].y() - q.y()
                
                if math.hypot(xi, yi) <= tolerance:
                    return -2 
                    
                dx = xi1 - xi
                dy = yi1 - yi
                edge_length = math.hypot(dx, dy)
                
                if edge_length > 0:
                    distance_to_line = abs(xi * yi1 - xi1 * yi) / edge_length
                    if distance_to_line <= tolerance:
                        dot_product = -(xi * dx + yi * dy) 
                        if 0 <= dot_product <= edge_length**2:
                            return -1 
                
                if (yi1 > 0 and yi <= 0) or (yi > 0 and yi1 <= 0):
                    xm = (xi1 * yi - xi * yi1) / (yi1 - yi) 
                    if xm > 0:
                        k += 1   
                        
        if k % 2 == 1:
            return 1 
        return 0    

    def getPointPolygonPositionWN(self, q: QPointF, complex_pol: list[QPolygonF]):
        # Analyze using Winding Number
        if not complex_pol or complex_pol[0].isEmpty():
            return 0
            
        # 1. Check outer boundary
        outer_status = self._getWindingNumberForRing(q, complex_pol[0])
        
        if outer_status != 1:
            return outer_status
            
        # 2. Check all holes
        for hole in complex_pol[1:]:
            if hole.isEmpty():
                continue
                
            hole_status = self._getWindingNumberForRing(q, hole)
            
            if hole_status == -1 or hole_status == -2:
                return hole_status # On the edge/vertex of a hole
                
            if hole_status == 1:
                return 0 # Inside a hole
                
        return 1

    def _getWindingNumberForRing(self, q: QPointF, ring: QPolygonF):
        # Standard WN logic for a single ring
        omega = 0.0
        n = len(ring)
        tolerance = 5.0 
        
        for i in range(n):
            xi = ring[i].x() - q.x()
            yi = ring[i].y() - q.y()
            
            xi1 = ring[(i+1)%n].x() - q.x()
            yi1 = ring[(i+1)%n].y() - q.y()
            
            if math.hypot(xi, yi) <= tolerance:
                return -2 
                
            dx = xi1 - xi
            dy = yi1 - yi
            edge_length = math.hypot(dx, dy)
            
            if edge_length > 0:
                distance_to_line = abs(xi * yi1 - xi1 * yi) / edge_length
                if distance_to_line <= tolerance:
                    dot_product = -(xi * dx + yi * dy)
                    if 0 <= dot_product <= edge_length**2:
                        return -1 
                
            cross_product = xi * yi1 - xi1 * yi
            dot_product = xi * xi1 + yi * yi1
            
            angle = math.atan2(cross_product, dot_product)
            omega += angle
            
        if abs(abs(omega) - 2 * math.pi) < 1e-5:
            return 1
        return 0

    def isInBoundingBox(self, q: QPointF, complex_pol: list[QPolygonF]):
        # Min-Max Box check the outer boundary
        if not complex_pol or complex_pol[0].isEmpty():
            return False
            
        outer_ring = complex_pol[0]
        
        x_coords = [p.x() for p in outer_ring]
        y_coords = [p.y() for p in outer_ring]
        
        min_x, max_x = min(x_coords), max(x_coords)
        min_y, max_y = min(y_coords), max(y_coords)
        
        if q.x() < min_x or q.x() > max_x or q.y() < min_y or q.y() > max_y:
            return False 
        return True