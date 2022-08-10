#version 330

in vec2 texCoord0;
in vec3 normal0;
in vec3 ToLightVector;
in vec3 ToCameraVector;

uniform vec3 LightColor;
uniform sampler2D DiffuseMap;
uniform float ShineDamper;
uniform float Reflectivity;

out vec4 FragColor;

void main()
{ 
  vec3 UnitNormal = normalize(normal0);
  vec3 UnitToLightVector = normalize(ToLightVector);
  vec3 UnitToCameraVector = normalize(ToCameraVector);
  
  float nDotL = dot(UnitNormal, UnitToLightVector);
  
  float Brightness = max(nDotL, 0.1);
  vec3 Diffuse = Brightness * LightColor;
  
  vec3 LightDirection = -UnitToLightVector;
  
  vec3 ReflectedLightDir = reflect(LightDirection, UnitNormal);
  float SpecularFactor = max(dot(ReflectedLightDir, UnitToCameraVector), 0.0);
  float DampedFactor = pow(SpecularFactor, ShineDamper);
  vec3 FinalSpecular = DampedFactor * LightColor * Reflectivity;
  
  vec4 TextureColor = texture(DiffuseMap, texCoord0);
  
  if (TextureColor.a < 0.5)
  {
    discard;
  }
  
  FragColor = vec4(Diffuse, 1.0) * TextureColor + vec4(FinalSpecular, 1.0);
}