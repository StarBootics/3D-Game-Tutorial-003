; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; AUTOMATICALLY GENERATED CODE, DO NOT MODIFY
; UNLESS YOU REALLY, REALLY, REALLY MEAN IT !!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Code generated by : Dev-Object - V2.0.0 Beta 7
; Project name : OpenGL 3D Game Tutorial
; File name : Entity.pbi
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

DeclareModule Entity
  
  Interface Entity
    
    GetModel.i()
    GetPosition.i()
    GetRotationX.f()
    GetRotationY.f()
    GetRotationZ.f()
    GetScale.f()
    GetDynamic.i()
    GetTextureIndex.l()
    SetModel(*Model.Model::Model)
    SetPosition(*Position.Vector3f::Vector3f)
    SetRotationX(RotationX.f)
    SetRotationY(RotationY.f)
    SetRotationZ(RotationZ.f)
    SetScale(Scale.f)
    IncreasePosition(DeltaX.f, DeltaY.f, DeltaZ.f)
    IncreaseRotation(DeltaX.f, DeltaY.f, DeltaZ.f)
    ComputeModelMatrix.i()
    Free()
    
  EndInterface
  
  ; Declare Free(*This)
  Declare.i New(*Model.Model::Model = #Null, *Position.Vector3f::Vector3f = #Null, RotationX.f = 0.0, RotationY.f = 0.0, RotationZ.f = 0.0, Scale.f = 0.0, Dynamic.i = #True, TextureIndex.l = 0)
  
EndDeclareModule

Module Entity
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Structure declaration <<<<<

  Structure Private_Members
    
    VirtualTable.i
    *Model.Model::Model
    Position.Vector3f::Vector3f
    RotationX.f
    RotationY.f
    RotationZ.f
    Scale.f
    Dynamic.i
    TextureIndex.l
    
  EndStructure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The observators <<<<<

  Procedure.i GetModel(*This.Private_Members)
    
    ProcedureReturn *This\Model
  EndProcedure
  
  Procedure.i GetPosition(*This.Private_Members)
    
    ProcedureReturn *This\Position
  EndProcedure
  
  Procedure.f GetRotationX(*This.Private_Members)
    
    ProcedureReturn *This\RotationX
  EndProcedure
  
  Procedure.f GetRotationY(*This.Private_Members)
    
    ProcedureReturn *This\RotationY
  EndProcedure
  
  Procedure.f GetRotationZ(*This.Private_Members)
    
    ProcedureReturn *This\RotationZ
  EndProcedure
  
  Procedure.f GetScale(*This.Private_Members)
    
    ProcedureReturn *This\Scale
  EndProcedure
  
  Procedure.i GetDynamic(*This.Private_Members)
    
    ProcedureReturn *This\Dynamic
  EndProcedure
  
  Procedure.l GetTextureIndex(*This.Private_Members)
  
    ProcedureReturn *This\TextureIndex
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The mutators <<<<<

  Procedure SetModel(*This.Private_Members, *Model.Model::Model)
    
    *This\Model = *Model
    
  EndProcedure
  
  Procedure SetPosition(*This.Private_Members, *Position.Vector3f::Vector3f)
    
    If *This\Position <> #Null
      *This\Position\Free()
    EndIf
    
    *This\Position = *Position
    
  EndProcedure
  
  Procedure SetRotationX(*This.Private_Members, RotationX.f)
    
    *This\RotationX = RotationX
    
  EndProcedure
  
  Procedure SetRotationY(*This.Private_Members, RotationY.f)
    
    *This\RotationY = RotationY
    
  EndProcedure
  
  Procedure SetRotationZ(*This.Private_Members, RotationZ.f)
    
    *This\RotationZ = RotationZ
    
  EndProcedure
  
  Procedure SetScale(*This.Private_Members, Scale.f)
    
    *This\Scale = Scale
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The IncreasePosition operator <<<<<
  
  Procedure IncreasePosition(*This.Private_Members, DeltaX.f, DeltaY.f, DeltaZ.f)
    
    If *This\Dynamic = #True
      *This\Position\SetI(*This\Position\GetI() + DeltaX)
      *This\Position\SetJ(*This\Position\GetJ() + DeltaY)
      *This\Position\SetK(*This\Position\GetK() + DeltaZ)
    EndIf
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The IncreaseRotation operator <<<<<
  
  Procedure IncreaseRotation(*This.Private_Members, DeltaX.f, DeltaY.f, DeltaZ.f)
    
    If *This\Dynamic = #True
      *This\RotationX = Mod(*This\RotationX + DeltaX, 360.0)
      *This\RotationY = Mod(*This\RotationY + DeltaY, 360.0)
      *This\RotationZ = Mod(*This\RotationZ + DeltaZ, 360.0)
    EndIf
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The ComputeModelMatrix operator <<<<<
  
  Procedure.i ComputeModelMatrix(*This.Private_Members)
    
    *ModelMatrix.Matrix44f::Matrix44f = Matrix44f::New()
    
    Translation.Matrix44f::Matrix44f = Matrix44f::New()
    Translation\TranslationEx(*This\Position)
    
    RotateX.Matrix44f::Matrix44f = Matrix44f::New()
    RotateX\RotateX(Radian(*This\RotationX))
    
    RotateY.Matrix44f::Matrix44f = Matrix44f::New()
    RotateY\RotateY(Radian(*This\RotationY))
    
    RotateZ.Matrix44f::Matrix44f = Matrix44f::New()
    RotateZ\RotateZ(Radian(*This\RotationZ))
    
    Scale.Matrix44f::Matrix44f = Matrix44f::New()
    Scale\Scale(*This\Scale, *This\Scale, *This\Scale)
    
    *ModelMatrix\Multiply(Translation)
    *ModelMatrix\Multiply(RotateX)
    *ModelMatrix\Multiply(RotateY)
    *ModelMatrix\Multiply(RotateZ)
    *ModelMatrix\Multiply(Scale)
    
    Translation\Free()
    RotateX\Free()
    RotateY\Free()
    RotateZ\Free()
    Scale\Free()
    
    ProcedureReturn *ModelMatrix
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Destructor <<<<<

  Procedure Free(*This.Private_Members)
    
    If *This\Position <> #Null
      *This\Position\Free()
    EndIf
    
    FreeStructure(*This)
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Constructor <<<<<

  Procedure.i New(*Model.Model::Model = #Null, *Position.Vector3f::Vector3f = #Null, RotationX.f = 0.0, RotationY.f = 0.0, RotationZ.f = 0.0, Scale.f = 0.0, Dynamic.i = #True, TextureIndex.l = 0)
    
    *This.Private_Members = AllocateStructure(Private_Members)
    *This\VirtualTable = ?START_METHODS
    
    *This\Model = *Model
    
    If *Position <> #Null
      *This\Position = *Position
    Else
      *This\Position = Vector3f::New()
    EndIf
    
    *This\RotationX = RotationX
    *This\RotationY = RotationY
    *This\RotationZ = RotationZ
    *This\Scale = Scale
    *This\Dynamic = Dynamic
    *This\TextureIndex = TextureIndex
    
    ProcedureReturn *This
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Virtual Table Entries <<<<<

  DataSection
    START_METHODS:
    Data.i @GetModel()
    Data.i @GetPosition()
    Data.i @GetRotationX()
    Data.i @GetRotationY()
    Data.i @GetRotationZ()
    Data.i @GetScale()
    Data.i @GetDynamic()
    Data.i @GetTextureIndex()
    Data.i @SetModel()
    Data.i @SetPosition()
    Data.i @SetRotationX()
    Data.i @SetRotationY()
    Data.i @SetRotationZ()
    Data.i @SetScale()
    Data.i @IncreasePosition()
    Data.i @IncreaseRotation()
    Data.i @ComputeModelMatrix()
    Data.i @Free()
    END_METHODS:
  EndDataSection
  
EndModule

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Code generated in : 00.001 seconds (217000.00 lines/second) <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<
; <<<<< END OF FILE <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 6.00 LTS (Linux - x64)
; Folding = -----
; EnableXP
; CompileSourceDirectory