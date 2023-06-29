public class Point {
    public Decimal x;
    public Decimal y;
    public String name;

    public Point(Decimal xCoordinate, Decimal yCoordinate,String name) {
        x = xCoordinate;
        y = yCoordinate;
        this.name = name;
    }


    public  Boolean inRectangle(Decimal bottom, Decimal top, Decimal left, Decimal right) {
        if (x >= left && x <= right && y >= bottom && y <= top) {
            return true;
        } else {
            return false;
        }
    }

    
    public override String toString() {
        return '(' + x + ', ' + y + ')';
    }
} 