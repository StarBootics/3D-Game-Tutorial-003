; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; AUTOMATICALLY GENERATED CODE, DO NOT MODIFY
; UNLESS YOU REALLY, REALLY, REALLY MEAN IT !!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Code generated by : Dev-Object - V2.0.0 Beta 7
; Project name : OpenGL 3D Game Tutorial
; File name : CapsuleBuilder.pbi
; File Version : 1.0.0
; Programmation : In progress
; Programmed by : Guillaume Saumure
; AKA : StarBootics
; E-mail : gsaumure@cgocable.ca
; Creation Date : August 2nd, 2022
; Last update : August 2nd, 2022
; Coded for PureBasic : V6.00 LTS
; Platform : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

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

DeclareModule CapsuleBuilder
  
  Interface CapsuleBuilder
    
    SetRadius(Radius.f)
    SetHeight(Height.f)
    SetResolution(Resolution.l)
    Built.i()
    Free()
    
  EndInterface
  
  Declare.i New(Radius.f = 1.0, Height.f = 2.0, Resolution.l = 16)
  
EndDeclareModule

Module CapsuleBuilder
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Structure declaration <<<<<

  Structure Private_Members
    
    VirtualTable.i
    Radius.f
    Height.f
    Resolution.l
    
  EndStructure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The mutators <<<<<

  Procedure SetRadius(*This.Private_Members, Radius.f)
    
    *This\Radius = Radius
    
  EndProcedure
  
  Procedure SetHeight(*This.Private_Members, Height.f)
    
    *This\Height = Height
    
  EndProcedure
  
  Procedure SetResolution(*This.Private_Members, Resolution.l)
    
    *This\Resolution = Resolution
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Built operator <<<<<

  Procedure.i Built(*This.Private_Members)
    
    *Mesh.Mesh::Mesh = Mesh::New()
    *Mesh\SetName("Capsule")
    
    LonCount = *This\Resolution
    LatCount = *This\Resolution
    
    If LatCount % 2 = 0
      LatCount + 1
    EndIf
    
    OffsetY.f = (*This\Height - *This\Radius * 2.0) * 0.5
    
    If OffsetY < 0.0
      OffsetY = 0.0
    EndIf
    
    LonStep.f = 2.0 * #PI / LonCount
    LatStep.f = #PI / LatCount
    StepX.f = 1.0 / LonCount
    
    For LatID = 0 To LatCount
      For LonID = 0 To LonCount
        
        Px.f = *This\Radius * Cos(LonID * LonStep) * Sin(LatID * LatStep)
        Py.f = *This\Radius * Cos(LatID * LatStep - #PI)
        Pz.f = *This\Radius * Sin(LonID * LonStep) * Sin(LatID * LatStep)
        Position.Vector3f::Vector3f = Vector3f::New(Px, Py, Pz)
        
        Normal.Vector3f::Vector3f = Vector3f::New(Px, Py, Pz)
        Normal\Normalize()
        
        Tx.f = -Sin(LatID * LatStep)
        Ty.f = 0.0
        Tz.f = Cos(LatID * LatStep)
        
        Tangent.Vector3f::Vector3f = Vector3f::New(Tx, Ty, Tz)
        Tangent\Normalize()
        
        If LatID > (LatCount >> 1)
          Position\SetJ(Position\GetJ() + OffsetY)
        Else
          Position\SetJ(Position\GetJ() - OffsetY)
        EndIf
        
        U.f = LonID / LonCount
        V.f = (Position\GetJ() + *This\Height) * 0.5 / *This\Height 
        *Mesh\AddVerticesEx(Vertex::New(Position, Normal, Tangent, Vector2f::New(U, V)))
        
      Next
    Next
    
    IndexV = LonCount + 1
    
    For LonID = 0 To LonCount - 1
      *Mesh\AddIndicesEx(Indice3::New(LonID, IndexV, IndexV + 1))
      IndexV + 1
    Next
    
    IndexV = LonCount + 1
   
    For LatID = 1 To LatCount - 2
      For LonID = 0 To LonCount - 1
        *Mesh\AddIndicesEx(Indice3::New(IndexV, IndexV + LonCount + 1, IndexV + 1))
        *Mesh\AddIndicesEx(Indice3::New(IndexV + 1, IndexV + LonCount + 1, IndexV + LonCount + 2))
        IndexV + 1
      Next
      IndexV + 1
    Next
    
    For LonID = 0 To LonCount - 1
      *Mesh\AddIndicesEx(Indice3::New(IndexV, IndexV + LonCount + 1, IndexV + 1))
      IndexV + 1
    Next
    
    ProcedureReturn *Mesh
  EndProcedure  
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Destructor <<<<<

  Procedure Free(*This.Private_Members)
    
    FreeStructure(*This)
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Constructor <<<<<

  Procedure.i New(Radius.f = 1.0, Height.f = 2.0, Resolution.l = 16)
    
    *This.Private_Members = AllocateStructure(Private_Members)
    *This\VirtualTable = ?START_METHODS
    
    *This\Radius = Radius
    *This\Height = Height
    *This\Resolution = Resolution
    
    ProcedureReturn *This
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Virtual Table Entries <<<<<

  DataSection
    START_METHODS:
    Data.i @SetRadius()
    Data.i @SetHeight()
    Data.i @SetResolution()
    Data.i @Built()
    Data.i @Free()
    END_METHODS:
  EndDataSection
  
EndModule

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Code generated in : 00.001 seconds (128000.00 lines/second) <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<
; <<<<< END OF FILE <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 6.00 LTS (Linux - x64)
; Folding = --
; EnableXP
; CompileSourceDirectory