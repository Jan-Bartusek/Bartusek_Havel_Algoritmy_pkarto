from PyQt6.QtCore import *
from PyQt6.QtGui import *
from PyQt6.QtWidgets import *

class Draw(QWidget):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # Store lists of polygons instead of single instances
        self.__buildings = []
        self.__mbrs = []
        self.__chs = []

    def setBuildings(self, buildings: list[QPolygonF]):
        # Set buildings and scale them to fit the canvas
        if not buildings:
            return
            
        self.__buildings = self._scaleToCanvas(buildings)
        # Clear previous results when loading new data
        self.__mbrs.clear()
        self.__chs.clear()
        self.repaint()

    def _scaleToCanvas(self, buildings: list[QPolygonF]) -> list[QPolygonF]:
        # Initialize global bounding box boundaries
        min_x, min_y = float('inf'), float('inf')
        max_x, max_y = float('-inf'), float('-inf')

        # Find global bounding box for all geometries
        for poly in buildings:
            for pt in poly:
                min_x = min(min_x, pt.x())
                max_x = max(max_x, pt.x())
                min_y = min(min_y, pt.y())
                max_y = max(max_y, pt.y())

        # Real world dimensions
        w_real = max_x - min_x
        h_real = max_y - min_y

        # Prevent division by zero if geometry is invalid
        if w_real == 0 or h_real == 0:
            return buildings

        # Canvas dimensions with padding
        padding = 20
        w_canvas = self.width() - 2 * padding
        h_canvas = self.height() - 2 * padding

        # Scale factor (maintains aspect ratio)
        scale = min(w_canvas / w_real, h_canvas / h_real)

        scaled_buildings = []
        for poly in buildings:
            scaled_poly = QPolygonF()
            for pt in poly:
                # Transform coordinates to screen space
                # PyQt Y-axis goes from top to bottom, so we invert Y
                x_new = padding + (pt.x() - min_x) * scale
                y_new = self.height() - padding - (pt.y() - min_y) * scale
                scaled_poly.append(QPointF(x_new, y_new))
                
            scaled_buildings.append(scaled_poly)

        return scaled_buildings

    def getBuildings(self) -> list[QPolygonF]:
        # Return the list of loaded buildings
        return self.__buildings

    def setMBRs(self, mbrs: list[QPolygonF]):
        # Set Minimum Bounding Rectangles
        self.__mbrs = mbrs
        self.repaint()

    def paintEvent(self, e):
        # Draw the geographic situation
        qp = QPainter(self)
        qp.begin(self)
        
        # Draw all original buildings
        qp.setPen(Qt.GlobalColor.black)
        qp.setBrush(Qt.GlobalColor.yellow)
        for building in self.__buildings:
            qp.drawPolygon(building)
            
        # Draw all generalized MBRs
        qp.setPen(Qt.GlobalColor.red)
        qp.setBrush(Qt.GlobalColor.transparent)
        for mbr in self.__mbrs:
            qp.drawPolygon(mbr)
            
        qp.end()

    def clearResult(self):
        # Clear processing results
        self.__mbrs.clear()
        self.__chs.clear()
        self.repaint()
        
    def clearAll(self):
        # Clear all loaded data
        self.__buildings.clear()
        self.clearResult()