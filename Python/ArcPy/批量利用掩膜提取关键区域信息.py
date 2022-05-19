import arcpy
from arcpy import env
from arcpy.sa import *
import os

root = "D:"

env.workspace = "%s/tmp" % root

scenario = ['bc26bi50',  'cc26bi50',  'ccmidbi',  'gs85bi50',  'hd85bi70',  'hemidbi',  'ip85bi70',  'mc85bi70',  'mg85bi50',  'mi85bi50',  'mr85bi70',  'no85bi50','bc26bi70',  'cc26bi70',  'cnmidbi',  'gs85bi70',  'he26bi50',  'hgmidbi',  'ipmidbi',  'melgmbi',  'mg85bi70',  'mi85bi70',  'mrlgmbi',  'no85bi70','bc45bi50',  'cc45bi50',  'current',  'hd26bi50',  'he26bi70',  'ip26bi50',  'mc26bi50',  'memidbi',  'mgmidbi',  'mr26bi50',  'mrmidbi','bc45bi70',  'cc45bi70',  'gs26bi50',  'hd26bi70',  'he45bi50',  'ip26bi70',  'mc26bi70',  'mg26bi50',  'mi26bi50',  'mr26bi70',  'no26bi50','bc60bi50',  'cc60bi50',  'gs26bi70',  'hd45bi50',  'he45bi70',  'ip45bi50',  'mc45bi50',  'mg26bi70',  'mi26bi70',  'mr45bi50',  'no26bi70','bc60bi70',  'cc60bi70',  'gs45bi50',  'hd45bi70',  'he60bi50',  'ip45bi70',  'mc45bi70',  'mg45bi50',  'mi45bi50',  'mr45bi70',  'no45bi50','bc85bi50',  'cc85bi50',  'gs45bi70',  'hd60bi50',  'he60bi70',  'ip60bi50',  'mc60bi50',  'mg45bi70',  'mi45bi70',  'mr60bi50',  'no45bi70','bc85bi70',  'cc85bi70',  'gs60bi50',  'hd60bi70',  'he85bi50',  'ip60bi70',  'mc60bi70',  'mg60bi50',  'mi60bi50',  'mr60bi70',  'no60bi50','bcmidbi',  'cclgmbi',  'gs60bi70',  'hd85bi50',  'he85bi70',  'ip85bi50',  'mc85bi50',  'mg60bi70',  'mi60bi70',  'mr85bi50',  'no60bi70']

bios = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19']

for scene in scenario:
	for bio in bios:
		infile = "%s/world_clim_1.4_asc/%s/%s%s.asc" % (root, scene, scene, bio)
		maskfile = "%s/mask/mask.shp" % root
		outfile = "%s/world_clim_mask/%s/bio_%s" % (root, scene, bio)
		check = "%s/world_clim_mask/%s" % (root, scene)
		if(not os.path.isdir(check)): os.makedirs(check)
		outExtractByMask = ExtractByMask(infile, maskfile)
		outExtractByMask.save(outfile)
		print("==============%s/%s==============" % (scene, bio))
	print("-----------------%s complete!-----------------" % scene)

print("All complete!!!")