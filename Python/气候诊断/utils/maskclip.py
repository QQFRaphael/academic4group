import shapefile
from matplotlib.path import Path
from matplotlib.patches import PathPatch


def shp2clip(originfig, ax, shpfile, fieldVals):
    """
    This method enables you to maskout the unneccessary data
                                            outside the interest region
    :param ax:  the Axes instance
    :param shpfile:  the shape file used for clip
    :param fieldVals:  thi features attributes value list in shape file,
                    outside the region the data is to be masked out
    :return:
    """
    sf = shapefile.Reader(shpfile,encoding="gbk")
    vertices = []
    codes = []
    for shape_rec in sf.shapeRecords():
        if shape_rec.record[3] in fieldVals:  # 注意这里需要指定你的字段的索引号，我的是第3个字段
            pts = shape_rec.shape.points
            prt = list(shape_rec.shape.parts) + [len(pts)]
            for i in range(len(prt) - 1):
                for j in range(prt[i], prt[i + 1]):
                    vertices.append((pts[j][0], pts[j][1]))
                codes += [Path.MOVETO]
                codes += [Path.LINETO] * (prt[i + 1] - prt[i] - 2)
                codes += [Path.CLOSEPOLY]
            clip = Path(vertices, codes)
            clip = PathPatch(clip, transform=ax.transData)
    for contour in originfig.collections:
        contour.set_clip_path(clip)
    return clip