; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; AUTOMATICALLY GENERATED CODE, DO NOT MODIFY
; UNLESS YOU REALLY, REALLY, REALLY MEAN IT !!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Code generated by : Dev-Object - V2.0.0 Beta 7
; Project name : OpenGL 3D Game Tutorial
; File name : SphereBuilder.pbi
; File Version : 1.0.0
; Programmation : In progress
; Programmed by : Guillaume Saumure
; AKA : StarBootics
; E-mail : gsaumure@cgocable.ca
; Creation Date : August 1st, 2022
; Last update : August 1st, 2022
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

DeclareModule SphereBuilder
  
  Interface SphereBuilder
    
    SetRadius(Radius.f)
    SetMeridian(Meridian.l)
    SetParallel(Parallel.l)
    Built.i()
    Free()
    
  EndInterface
  
  ; Declare Free(*This)
  Declare.i New(Radius.f = 5.0, Meridian.l = 32, Parallel.l = 32)
  
EndDeclareModule

Module SphereBuilder
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Structure declaration <<<<<

  Structure Private_Members
    
    VirtualTable.i
    Radius.f
    Meridian.l
    Parallel.l
    
  EndStructure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Helper Macro <<<<<
  
  Macro LinearlySpacedValue(IncrementID, IncrementMax, MinValue, MaxValue)
    
     ((MinValue) + ((MaxValue) - (MinValue)) * ((IncrementID) / (IncrementMax)))
  
  EndMacro
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The mutators <<<<<

  Procedure SetRadius(*This.Private_Members, Radius.f)
    
    *This\Radius = Radius
    
  EndProcedure
  
  Procedure SetMeridian(*This.Private_Members, Meridian.l)
    
    *This\Meridian = Meridian
    
  EndProcedure
  
  Procedure SetParallel(*This.Private_Members, Parallel.l)
    
    *This\Parallel = Parallel
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Built operator <<<<<
  
  Procedure.i Built(*This.Private_Members)
    
    *Mesh.Mesh::Mesh = Mesh::New()
    *Mesh\SetName("Sphere")
    
    For ParallelID = 0 To *This\Parallel
      
      Theta.f = LinearlySpacedValue(ParallelID, *This\Parallel, -#PI/2.0, #PI / 2.0)
      CTheta.f = Cos(Theta)
      STheta.f = Sin(Theta)
      V.f = LinearlySpacedValue(ParallelID, *This\Parallel, 1.0, 0.0)
      
      For MeridianID = 0 To *This\Meridian
        
        Phi.f = LinearlySpacedValue(MeridianID, *This\Meridian, 0.0, 2.0 * #PI)
        CPhi.f = Cos(Phi)
        SPhi.f = Sin(Phi)
        
        Px.f = *This\Radius * CTheta * CPhi
        Py.f = *This\Radius * STheta
        Pz.f = *This\Radius * CTheta * SPhi
        Position.Vector3f::Vector3f = Vector3f::New(Px, Py, Pz)
        
        Normal.Vector3f::Vector3f = Vector3f::New(Px, Py, Pz)
        Normal\Normalize()
        
        Tx.f = -SPhi
        Ty.f = 0.0
        Tz.f = CPhi
        Tangent.Vector3f::Vector3f = Vector3f::New(Tx, Ty, Tz)
        Tangent\Normalize()
        
        U.f = Phi / (2.0 * #PI)
        *Mesh\AddVerticesEx(Vertex::New(Position, Normal, Tangent, Vector2f::New(U, V)))

      Next

    Next
    
    
    For ParallelID = 0 To *This\Parallel - 1
      
      For MeridianID = 0 To *This\Meridian - 1
        
        TL.l = MeridianID + ParallelID * (*This\Meridian + 1)
        TR.l = (MeridianID + 1) + ParallelID * (*This\Meridian + 1)
        BL.l = MeridianID + (ParallelID+1) * (*This\Meridian + 1)
        BR.l = (MeridianID + 1) + (ParallelID+1) * (*This\Meridian + 1)
        
        *Mesh\AddIndicesEx(Indice3::New(TL, BL, TR))
        *Mesh\AddIndicesEx(Indice3::New(BL, BR, TR))
        
      Next
      
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

  Procedure.i New(Radius.f = 5.0, Meridian.l = 32, Parallel.l = 32)
    
    *This.Private_Members = AllocateStructure(Private_Members)
    *This\VirtualTable = ?START_METHODS
    
    *This\Radius = Radius
    *This\Meridian = Meridian
    *This\Parallel = Parallel
    
    ProcedureReturn *This
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Virtual Table Entries <<<<<

  DataSection
    START_METHODS:
    Data.i @SetRadius()
    Data.i @SetMeridian()
    Data.i @SetParallel()
    Data.i @Built()
    Data.i @Free()
    END_METHODS:
  EndDataSection
  
EndModule

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Code generated in : 00.001 seconds (107000.00 lines/second) <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<
; <<<<< END OF FILE <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 6.00 LTS (Linux - x64)
; Folding = ---
; EnableXP
; CompileSourceDirectory