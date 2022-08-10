; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Project Name : OpenGL 3D Game Tutorial
; File name : Game - Main.pb
; File Version : 1.0.0
; Programming : OK
; Programmed by : Guillaume Saumure
; AKA : StarBootics
; Email : gsaumure@cgocable.ca
; Date : May 21st, 2021
; Last Update : August 10th, 2022
; Coded for PureBasic : V6.00 LTS
; Platform : Windows, Linux, MacOS
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

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Programming Notes
;
; 1. New stuff introduced in this tutorial :
;    - TinyMarsenneTwister
;    - Material
;    - HeightsGeneratorParams
;    - HeightsGenerator
;    - TerrainVertex
;    - TerrainTile
;    - Terrain
;    - TerrainShader
;    - TerrainRenderer
;    - Vector4f
;    - TorusBuilder
;    - SphereBuilder
;    - CapsuleBuilder
;    - EntitiesBatch
;    - EntitiesBatches
;
; 2. Correction/Addition from previous Tutorials
;    - Camera Transformed Position
;
; 3. If everything goes as planned, you should get a multi-texture procedural terrain with trees and ferns
;    placed randomly on the terrain, 2 wood crates, 2 torus, 2 spheres and 2 capsules.
;    
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

IncludeFile "Source/Import/GLFW Import - Module.pbi"
IncludeFile "Source/Import/GLEW Import - Module.pbi"

IncludeFile "Source/Utils/ErrorLog.pbi"
IncludeFile "Source/Utils/BuiltPathDirectories.pbi"
IncludeFile "Source/Utils/CustomPrefs.pbi"
IncludeFile "Source/Utils/Language.pbi"
IncludeFile "Source/Utils/TinyMersenneTwister.pbi"
IncludeFile "Source/Utils/FloatGrid2D.pbi"

IncludeFile "Source/CallBackSystem/CallBackSystem.pbi"
IncludeFile "Source/Game/GameFolderSystem.pbi"

IncludeFile "Source/Screen/Screen.pbi"

IncludeFile "Source/Maths/Vector2f.pbi"
IncludeFile "Source/Maths/Vector3f.pbi"
IncludeFile "Source/Maths/Vector4f.pbi"

IncludeFile "Source/Maths/Matrix44f.pbi"

IncludeFile "Source/Material/Color3f.pbi"
IncludeFile "Source/Material/Color4f.pbi"

IncludeFile "Source/RenderingEngine/ShaderProgram.pbi"

IncludeFile "Source/Material/Texture.pbi"
IncludeFile "Source/Material/Material.pbi"

IncludeFile "Source/Mesh/Vertex.pbi"
IncludeFile "Source/Mesh/Indice3.pbi"
IncludeFile "Source/Mesh/Mesh.pbi"
IncludeFile "Source/Mesh/TorusBuilder.pbi"
IncludeFile "Source/Mesh/SphereBuilder.pbi"
IncludeFile "Source/Mesh/CapsuleBuilder.pbi"

IncludeFile "Source/RenderingEngine/TextureLoader.pbi"

IncludeFile "Source/Model/Model.pbi"

IncludeFile "Source/Entities/Light.pbi"
IncludeFile "Source/Entities/Camera.pbi"
IncludeFile "Source/Entities/Entity.pbi"
IncludeFile "Source/Entities/Entities.pbi"
IncludeFile "Source/Entities/EntitiesBatch.pbi"
IncludeFile "Source/Entities/EntitiesBatches.pbi"

IncludeFile "Source/Terrain/HeightsGeneratorParams.pbi"
IncludeFile "Source/Terrain/HeightsGenerator.pbi"
IncludeFile "Source/Terrain/TerrainVertex.pbi"
IncludeFile "Source/Terrain/TerrainTile.pbi"
IncludeFile "Source/Terrain/Terrain.pbi"

IncludeFile "Source/RenderingEngine/EntityShader.pbi"
IncludeFile "Source/RenderingEngine/EntityRenderer.pbi"

IncludeFile "Source/RenderingEngine/TerrainShader.pbi"
IncludeFile "Source/RenderingEngine/TerrainRenderer.pbi"

IncludeFile "Source/RenderingEngine/MasterRenderer.pbi"

IncludeFile "Source/CoreEngine/CoreEngine.pbi"

IncludeFile "Source/Game/Game.pbi"

MyGame.Game::Game = Game::New()

MyGame\Load()
MyGame\Run()
MyGame\Free()

; <<<<<<<<<<<<<<<<<<<<<<<
; <<<<< END OF FILE <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 6.00 LTS (Linux - x64)
; Optimizer
; EnableXP
; Executable = Test
; DisableDebugger
; CompileSourceDirectory
; Compiler = PureBasic 6.00 LTS - C Backend (Linux - x64)