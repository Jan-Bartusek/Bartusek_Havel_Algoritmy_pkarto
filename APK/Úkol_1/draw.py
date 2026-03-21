from PyQt6.QtCore import *
from PyQt6.QtGui import *
from PyQt6.QtWidgets import *

class Draw(QWidget):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        #List of complex polygons
        self.__polygons = [[QPolygonF()]]
        self.__q = QPointF(100, 100)
        self.__add_vertex = True
        self.__highlighted_indices = []

    def mousePressEvent(self, e):
        x = e.position().x()
        y = e.position().y()
        
        if self.__add_vertex:
            # Left click: Add point to the current ring
            if e.button() == Qt.MouseButton.LeftButton:
                self.__polygons[-1][-1].append(QPointF(x, y))
                
            # Right click: Finish current ring, start a new hole in the same polygon
            elif e.button() == Qt.MouseButton.RightButton:
                if not self.__polygons[-1][-1].isEmpty():
                    self.__polygons[-1].append(QPolygonF())
                    
            # Middle click: Finish the whole complex polygon, start a new distinct polygon
            elif e.button() == Qt.MouseButton.MiddleButton:
                # Clean up empty rings
                if self.__polygons[-1][-1].isEmpty():
                    self.__polygons[-1].pop()
                # Start a new complex polygon if the current one has data
                if self.__polygons[-1]:
                    self.__polygons.append([QPolygonF()])
        else: 
            self.__q.setX(x)
            self.__q.setY(y)
                    
        self.repaint()

    def paintEvent(self, e):
        qp = QPainter(self)
        
        for i, complex_pol in enumerate(self.__polygons):
            # Skip if there is no outer boundary
            if not complex_pol or complex_pol[0].isEmpty():
                continue
                
            qp.setPen(Qt.GlobalColor.black)
            
            if i in self.__highlighted_indices:
                qp.setBrush(Qt.GlobalColor.cyan)
            else:
                qp.setBrush(Qt.GlobalColor.yellow)
                
            # QPainterPath for rendering holes with OddEvenFill rule
            path = QPainterPath()
            path.setFillRule(Qt.FillRule.OddEvenFill) 
            
            # Add outer boundary and all holes to the path
            for ring in complex_pol:
                if not ring.isEmpty():
                    path.addPolygon(ring)
                    
            qp.drawPath(path)
        
        qp.setBrush(Qt.GlobalColor.green)
        r = 10
        qp.drawEllipse(int(self.__q.x() - r), int(self.__q.y() - r), 2 * r, 2 * r)
        
    def changeStatus(self):
        self.__add_vertex = not self.__add_vertex
        
    def clearData(self):
        self.__polygons = [[QPolygonF()]]
        self.__highlighted_indices.clear()
        self.__q.setX(-25)
        self.__q.setY(-25)
        self.repaint()
    
    def getQ(self):
        return self.__q
    
    def getPolygons(self):
        return self.__polygons
        
    def setHighlightedPolygons(self, indices):
        self.__highlighted_indices = indices
        self.repaint()
        
    def setPolygons(self, loaded_polygons):
        # Set polygons loaded from external file
        self.__polygons = loaded_polygons
        self.__highlighted_indices.clear()
        self.repaint()