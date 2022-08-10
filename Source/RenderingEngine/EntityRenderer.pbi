; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; AUTOMATICALLY GENERATED CODE, DO NOT MODIFY
; UNLESS YOU REALLY, REALLY, REALLY MEAN IT !!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Code generated by : Dev-Object - V2.0.0 Beta 7
; Project name : OpenGL 3D Game Tutorial
; File name : EntityRenderer.pbi
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

DeclareModule EntityRenderer
  
  Interface EntityRenderer
    
    GetEntityShader.i()
    Render(*EntitiesBatches.EntitiesBatches::EntitiesBatches, *Camera.Camera::Camera, *Light.Light::Light)
    Free()
    
  EndInterface
  
  Declare.i New(*GameFolderSystem.GameFolderSystem::GameFolderSystem, *DefaultMaterial.Material::Material)
  
EndDeclareModule

Module EntityRenderer
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Structure declaration <<<<<

  Structure Private_Members
    
    VirtualTable.i
    EntityShader.EntityShader::EntityShader
    *DefaultMaterial.Material::Material
    
  EndStructure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The observators <<<<<

  Procedure.i GetEntityShader(*This.Private_Members)
    
    ProcedureReturn *This\EntityShader
  EndProcedure

  Procedure Render(*This.Private_Members, *EntitiesBatches.EntitiesBatches::EntitiesBatches, *Camera.Camera::Camera, *Light.Light::Light)
    
    *This\EntityShader\Bind()
 
    ViewMatrix.Matrix44f::Matrix44f = *Camera\ComputeViewMatrix()
    *This\EntityShader\SendViewMatrix(ViewMatrix)
    ViewMatrix\Free()
    
    *This\EntityShader\SendViewPosition(*Camera\GetTransformedPosition())
    *This\EntityShader\SendLight(*Light)
    
    *EntitiesBatches\ResetBatches()
    
    While *EntitiesBatches\NextBatches()
      
      *EntitiesBatch.EntitiesBatch::EntitiesBatch = *EntitiesBatches\GetBatches()
      *Model.Model::Model = *EntitiesBatch\GetModel()
      *Mesh.Mesh::Mesh = *Model\GetMesh()
      *Material.Material::Material = *Model\GetMaterial()
      *Material\BindTexture(OGL::#GL_TEXTURE0, "DiffuseMap", *This\DefaultMaterial)
      *This\EntityShader\SendMaterialRelatedUniforms(*Material, *This\DefaultMaterial)
      
      If *Material\FindIntegers("HasTransparency")
        
        If *Material\GetIntegers() = 1
          GL20::glDisable(#GL_CULL_FACE)
          GL20::glCullFace(#GL_BACK)
        EndIf
        
      EndIf
      
        
      *Mesh\BindVertexArrayObject()
      
      *Entities.Entities::Entities = *EntitiesBatch\GetEntities()
      
      *Entities\ResetEntities()
      
      While *Entities\NextEntities()
        *Entity.Entity::Entity = *Entities\GetEntities()
        ModelMatrix.Matrix44f::Matrix44f = *Entity\ComputeModelMatrix()
        *This\EntityShader\SendModelMatrix(ModelMatrix)
        *This\EntityShader\SendTextureCoordinateModifierUniforms(*Entity\GetTextureIndex(), *Material, *This\DefaultMaterial)
        ModelMatrix\Free()
        *Mesh\Draw()
      Wend
      
      *Mesh\UnbindVertexArrayObject()
      
      If *Material\FindIntegers("HasTransparency")
        
        If *Material\GetIntegers() = 1
          GL20::glEnable(#GL_CULL_FACE)
          GL20::glCullFace(#GL_BACK)
        EndIf
        
      EndIf
      
    Wend
    
    *This\EntityShader\Unbind()
    
  EndProcedure

  ; <<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Destructor <<<<<

  Procedure Free(*This.Private_Members)

    If *This\EntityShader <> #Null
      *This\EntityShader\Free()
    EndIf
    
    FreeStructure(*This)
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Constructor <<<<<

  Procedure.i New(*GameFolderSystem.GameFolderSystem::GameFolderSystem, *DefaultMaterial.Material::Material)
    
    *This.Private_Members = AllocateStructure(Private_Members)
    *This\VirtualTable = ?START_METHODS
    
    *This\EntityShader = EntityShader::New()
    *This\EntityShader\Compile(*GameFolderSystem\GetShadersPath())
    *This\DefaultMaterial = *DefaultMaterial
    
    ProcedureReturn *This
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Virtual Table Entries <<<<<

  DataSection
    START_METHODS:
    Data.i @GetEntityShader()
    Data.i @Render()
    Data.i @Free()
    END_METHODS:
  EndDataSection
  
EndModule

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Code generated in : 00.001 seconds (144000.00 lines/second) <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<
; <<<<< END OF FILE <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 6.00 LTS (Linux - x64)
; Folding = --
; EnableXP
; CompileSourceDirectory