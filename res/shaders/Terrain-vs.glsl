#version 330

layout (location=0) in vec3 Position;
layout (location=1) in vec3 Normal;
layout (location=2) in vec2 UVMap;

out vec2 texCoord0;
out vec3 normal0;
out vec3 ToLightVector;
out vec3 ToCameraVector;

uniform mat4 ModelMatrix;
uniform mat4 ViewMatrix;
uniform mat4 ProjectionMatrix;
uniform vec3 LightPosition;
uniform vec3 ViewPos;

void main()
{
  vec4 WorldPosition = ModelMatrix * vec4(Position, 1.0);
  gl_Position = ProjectionMatrix * ViewMatrix * WorldPosition;
  
  normal0 = (ModelMatrix * vec4(Normal, 0.0)).xyz;
  ToLightVector = LightPosition - WorldPosition.xyz;
  ToCameraVector = ViewPos - WorldPosition.xyz;
  texCoord0 = UVMap;
}
