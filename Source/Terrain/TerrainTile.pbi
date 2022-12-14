; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; AUTOMATICALLY GENERATED CODE, DO NOT MODIFY
; UNLESS YOU REALLY, REALLY, REALLY MEAN IT !!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Code generated by : Dev-Object - V2.0.0 Beta 7
; Project name : OpenGL 3D Game Tutorial
; File name : TerrainTile.pbi
; File Version : 0.0.0
; Programmation : In progress
; Programmed by : Guillaume Saumure
; AKA : StarBootics
; E-mail : gsaumure@cgocable.ca
; Creation Date : July 28th, 2022
; Last update : July 28th, 2022
; Coded for PureBasic : V6.00 LTS
; Platform : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; The MIT License (MIT)
; 
; Copyright (c) 2022 Guillaume Saumure
; 
; Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
; associated documentation files (the "Software"), to deal in the Software without restriction, including 
; without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
; copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the 
; following conditions:
; 
; The above copyright notice and this permission notice shall be included in all copies or substantial 
; portions of the Software.
; 
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
; LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO 
; EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
; IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
; THE USE OR OTHER DEALINGS IN THE SOFTWARE.
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

DeclareModule TerrainTile
  
  Interface TerrainTile
    
    GetGridX.l()
    GetGridZ.l()
    GetHeightOfTerrainTile.f(WorldX.f, WorldZ.f)
    SetGridX(GridX.l)
    SetGridZ(GridZ.l)
    ClearVertices()
    ClearIndices()
    Built(VertexCount.l, Size.f, *HeightsGenerator.HeightsGenerator::HeightsGenerator)
    SendToGPU()
    FreeFromGPU()
    Draw(ForShadowMap.i)
    FormatedGridCoords.s()
    Free()
    
  EndInterface
  
  ; Declare Free(*This)
  Declare.i New(GridX.l, GridZ.l)
  
EndDeclareModule

Module TerrainTile
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Structures declaration <<<<<
  
  Structure Point3D
    
    x.f
    y.f
    z.f
   
  EndStructure
  
  Structure Private_Members
    
    VirtualTable.i
    GridX.l
    GridZ.l
    Size.f
    VertexCount.l
    FormatedGridCoords.s
    List Vertices.TerrainVertex::TerrainVertex()
    List Indices.Indice3::Indice3()
    Heights.FloatGrid2D::FloatGrid2D
    IndiceCount.l
    VertexArrayObjectID.l
    
  EndStructure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Support procedures <<<<<
  
  Procedure.i CalculateNormal(X.l, Z.l, *HeightsGenerator.HeightsGenerator::HeightsGenerator)
    
    HL.f = *HeightsGenerator\CalculateHeight(X-1, Z)
    HR.f = *HeightsGenerator\CalculateHeight(X+1, Z)
    HD.f = *HeightsGenerator\CalculateHeight(X, Z-1)
    HU.f = *HeightsGenerator\CalculateHeight(X, Z+1)
    
    *Normal.Vector3f::Vector3f = Vector3f::New(HL - HR, 2.0, HD - HU)
    *Normal\Normalize()
    
    ProcedureReturn *Normal
  EndProcedure
  
  Procedure.f BarryCentric(*P1.Point3D, *P2.Point3D, *P3.Point3D, PosX.f, PosZ.f)
    
    det.f = (*P2\z - *P3\z) * (*P1\x - *P3\x) + (*P3\x - *P2\x) * (*P1\z - *P3\z)
		l1.f = ((*P2\z - *P3\z) * (PosX - *P3\x) + (*P3\x - *P2\x) * (PosZ - *P3\z)) / det
		l2.f = ((*P3\z - *P1\z) * (PosX - *P3\x) + (*P1\x - *P3\x) * (PosZ - *P3\z)) / det
		l3.f = 1.0 - l1 - l2
		
    ProcedureReturn l1 * *P1\y + l2 * *P2\y + l3 * *P3\y
  EndProcedure
  
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The observators <<<<<

  Procedure.l GetGridX(*This.Private_Members)
    
    ProcedureReturn *This\GridX
  EndProcedure
  
  Procedure.l GetGridZ(*This.Private_Members)
    
    ProcedureReturn *This\GridZ
  EndProcedure
  
  Procedure.f GetHeightOfTerrainTile(*This.Private_Members, WorldX.f, WorldZ.f)
    
    Define P1.Point3D, P2.Point3D, P3.Point3D
    
    TerrainX.f = WorldX - (*This\GridX * *This\Size)
    TerrainZ.f = WorldZ - (*This\GridZ * *This\Size)
    
    GridSquareSize.f = *This\Size / (*This\VertexCount-1)
    GridX.l = Int(Round(TerrainX / GridSquareSize, #PB_Round_Down))
    GridZ.l = Int(Round(TerrainZ / GridSquareSize, #PB_Round_Down))

    If (GridX >= (*This\VertexCount-1) Or GridZ >= (*This\VertexCount-1)) Or (GridX < 0 Or GridZ < 0)
      ProcedureReturn 0.0
    EndIf

    CoordX.f = Mod(TerrainX, GridSquareSize) / GridSquareSize
    CoordZ.f = Mod(TerrainZ, GridSquareSize) / GridSquareSize
    
    If CoordX <= (1-CoordZ)
      P1\x = 0.0 : P1\y = *This\Heights\GetElement(GridZ, GridX) : P1\z = 0.0
      P2\x = 1.0 : P2\y = *This\Heights\GetElement(GridZ, GridX+1) : P2\z = 0.0
      P3\x = 0.0 : P3\y = *This\Heights\GetElement(GridZ+1, GridX) : P3\z = 1.0
      CalculatedHeight.f = BarryCentric(P1, P2, P3, CoordX, CoordZ)
    Else
      P1\x = 1.0 : P1\y = *This\Heights\GetElement(GridZ, GridX+1) : P1\z = 0.0
      P2\x = 1.0 : P2\y = *This\Heights\GetElement(GridZ+1, GridX+1) : P2\z = 1.0
      P3\x = 0.0 : P3\y = *This\Heights\GetElement(GridZ+1, GridX) : P3\z = 1.0
      CalculatedHeight.f = BarryCentric(P1, P2, P3, CoordX, CoordZ)
    EndIf
    
    ProcedureReturn CalculatedHeight
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The mutators <<<<<

  Procedure SetGridX(*This.Private_Members, GridX.l)
    
    *This\GridX = GridX
    
  EndProcedure
  
  Procedure SetGridZ(*This.Private_Members, GridZ.l)
    
    *This\GridZ = GridZ
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Clear linked list operator(s) <<<<<

  Procedure ClearVertices(*This.Private_Members)
    
    ForEach *This\Vertices()
      If *This\Vertices() <> #Null
        *This\Vertices()\Free()
      EndIf
    Next
    
    ClearList(*This\Vertices())
    
  EndProcedure
  
  Procedure ClearIndices(*This.Private_Members)
    
    ForEach *This\Indices()
      If *This\Indices() <> #Null
        *This\Indices()\Free()
      EndIf
    Next
    
    ClearList(*This\Indices())
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Built operator <<<<<
  
  Procedure Built(*This.Private_Members, VertexCount.l, Size.f, *HeightsGenerator.HeightsGenerator::HeightsGenerator)
    
    *This\VertexCount = VertexCount
    *This\Size = Size
    *This\Heights\Resize(VertexCount, VertexCount)
    
    For i = 0 To VertexCount - 1
      
      For j = 0 To VertexCount - 1
        
        AddElement(*This\Vertices())
        
        Px.f = j / (VertexCount - 1) * *This\Size + (*This\GridX * *This\Size)
        Py.f = *HeightsGenerator\CalculateHeight(j, i)
        Pz.f = i / (VertexCount - 1) * *This\Size + (*This\GridZ * *This\Size)
        *This\Heights\SetElement(i, j, Py)
        
        U.f = j / (VertexCount - 1)
        V.f = i / (VertexCount - 1)
        
        *This\Vertices() = TerrainVertex::New(Vector3f::New(Px, Py, Pz), CalculateNormal(j, i, *HeightsGenerator), Vector2f::New(U, V))
        
      Next
      
    Next
    
    For GZ = 0 To VertexCount - 2
      For GX = 0 To VertexCount - 2
        
        TopLeft.l = (GZ * VertexCount) + GX
        TopRight.l = TopLeft + 1
        BottomLeft.l = ((GZ+1) * VertexCount) + GX
        BottomRight.l = BottomLeft + 1
        
        AddElement(*This\Indices())
        *This\Indices() = Indice3::New(TopLeft, BottomLeft, TopRight)
        AddElement(*This\Indices())
        *This\Indices() = Indice3::New(TopRight, BottomLeft, BottomRight)
        
      Next
    Next
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The SendToGPU operator <<<<<
  
  Procedure SendToGPU(*This.Private_Members)
    
    VertexBuffer.i = AllocateMemory(ListSize(*This\Vertices()) * TerrainVertex::#MEMORY_SIZE)
    Ptr.i = VertexBuffer
    
    ForEach *This\Vertices()
      Ptr = *This\Vertices()\Interleave(Ptr)
    Next
    
    *This\IndiceCount = ListSize(*This\Indices())
    
    IndiceBuffer.i = AllocateMemory(*This\IndiceCount * Indice3::#MEMORY_SIZE)
    Ptr.i = IndiceBuffer
    
    ForEach *This\Indices()
      CopyMemory(*This\Indices()\Access(), Ptr, Indice3::#MEMORY_SIZE)
      Ptr + Indice3::#MEMORY_SIZE
    Next
    
    GL30::glGenVertexArrays(1, @*This\VertexArrayObjectID)
    GL30::glBindVertexArray(*This\VertexArrayObjectID)
    
    GL20::glGenBuffers(1, @VertexBufferObjectID.l)
    GL20::glBindBuffer(OGL::#GL_ARRAY_BUFFER, VertexBufferObjectID)
    GL20::glBufferData(OGL::#GL_ARRAY_BUFFER, MemorySize(VertexBuffer), VertexBuffer, OGL::#GL_STATIC_DRAW)
    
    GL20::glGenBuffers(1, @IndiceBufferObjectID.l)
    GL20::glBindBuffer(OGL::#GL_ELEMENT_ARRAY_BUFFER, IndiceBufferObjectID)
    GL20::glBufferData(OGL::#GL_ELEMENT_ARRAY_BUFFER, MemorySize(IndiceBuffer), IndiceBuffer, OGL::#GL_STATIC_DRAW)
    
    GL20::glEnableVertexAttribArray(0)
    GL20::glEnableVertexAttribArray(1)
    GL20::glEnableVertexAttribArray(2)
    
    GL20::glVertexAttribPointer(0, 3, #GL_FLOAT, #GL_FALSE, TerrainVertex::#MEMORY_SIZE, 0)
    GL20::glVertexAttribPointer(1, 3, #GL_FLOAT, #GL_FALSE, TerrainVertex::#MEMORY_SIZE, 12)
    GL20::glVertexAttribPointer(2, 2, #GL_FLOAT, #GL_FALSE, TerrainVertex::#MEMORY_SIZE, 24)
    
    GL20::glDisableVertexAttribArray(0)
    GL20::glDisableVertexAttribArray(1)
    GL20::glDisableVertexAttribArray(2)
    
    GL30::glBindVertexArray(0)
    
    FreeMemory(VertexBuffer)
    FreeMemory(IndiceBuffer)
    
    GL20::glDeleteBuffers(1, @VertexBufferObjectID)
    GL20::glDeleteBuffers(1, @IndiceBufferObjectID)
    
    ClearVertices(*This)
    ClearIndices(*This)
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The FreeFromGPU operator <<<<<
  
  Procedure FreeFromGPU(*This.Private_Members)
    
    GL30::glDeleteVertexArrays(1, @*This\VertexArrayObjectID)
    
    *This\VertexArrayObjectID = 0
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Draw operator <<<<<
  
  Procedure Draw(*This.Private_Members, ForShadowMap.i)
    
    GL30::glBindVertexArray(*This\VertexArrayObjectID)
    
    GL20::glEnableVertexAttribArray(0)
    
    If ForShadowMap = #False
      GL20::glEnableVertexAttribArray(1)
      GL20::glEnableVertexAttribArray(2)
    EndIf
    
    GL20::glDrawElements(#GL_TRIANGLES, 3 * *This\IndiceCount, #GL_UNSIGNED_INT, 0)
    
    GL20::glDisableVertexAttribArray(0)
    
    If ForShadowMap = #False
      GL20::glDisableVertexAttribArray(1)
      GL20::glDisableVertexAttribArray(2)
    EndIf
    
    GL30::glBindVertexArray(0)
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The FormatedGridCoords operator <<<<<
  
  Procedure.s FormatedGridCoords(*This.Private_Members)
  
    ProcedureReturn *This\FormatedGridCoords
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Destructor <<<<<

  Procedure Free(*This.Private_Members)
    
    ForEach *This\Vertices()
      If *This\Vertices() <> #Null
        *This\Vertices()\Free()
      EndIf
    Next
    
    ForEach *This\Indices()
      If *This\Indices() <> #Null
        *This\Indices()\Free()
      EndIf
    Next
    
    If *This\Heights <> #Null
      *This\Heights\Free()
    EndIf
    
    FreeStructure(*This)
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Constructor <<<<<

  Procedure.i New(GridX.l, GridZ.l)
    
    *This.Private_Members = AllocateStructure(Private_Members)
    *This\VirtualTable = ?START_METHODS
    
    *This\GridX = GridX
    *This\GridZ = GridZ
    *This\FormatedGridCoords = Str(GridX) + "-" + Str(GridZ)
    *This\Heights = FloatGrid2D::New(5, 5)
    
    ProcedureReturn *This
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Virtual Table Entries <<<<<

  DataSection
    START_METHODS:
    Data.i @GetGridX()
    Data.i @GetGridZ()
    Data.i @GetHeightOfTerrainTile()
    Data.i @SetGridX()
    Data.i @SetGridZ()
    Data.i @ClearVertices()
    Data.i @ClearIndices()
    Data.i @Built()
    Data.i @SendToGPU()
    Data.i @FreeFromGPU()
    Data.i @Draw()
    Data.i @FormatedGridCoords()
    Data.i @Free()
    END_METHODS:
  EndDataSection
  
EndModule

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Code generated in : 00.001 seconds (229000.00 lines/second) <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<
; <<<<< END OF FILE <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 6.00 LTS (Linux - x64)
; Folding = --4-
; EnableXP
; CompileSourceDirectory