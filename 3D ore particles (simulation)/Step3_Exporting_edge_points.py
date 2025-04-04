#Step 3: Exporting the coordinates of the edge points of a 3D ore particle model. This script runs in Semcad X.

import s41_v1 as s41
import s41_v1.model as model

cyl = model.AllEntities()['entity name']

filter = s41.analysis.core.ModelToGridFilter()
filter.Entity = cyl
filter.Update()
meshCylinder = filter.Outputs[0]

meshData = meshCylinder.Data

res = open("the CSV file path", "w")
for idx in range(meshData.NumberOfPoints):
    edgePoint = meshData.GetPoint(idx)
    res.write(str(edgePoint[0])+","+str(edgePoint[1])+","+str(edgePoint[2])+"\n")

res.close()