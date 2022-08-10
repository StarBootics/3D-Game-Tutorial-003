#version 330

in vec2 texCoord0;
in vec3 normal0;
in vec3 ToLightVector;
in vec3 ToCameraVector;

uniform vec3 LightColor;

uniform sampler2D Background;
uniform sampler2D RedTexture;
uniform sampler2D GreenTexture;
uniform sampler2D BlueTexture;
uniform sampler2D BlendMap;

uniform float ShineDamper;
uniform float Reflectivity;
uniform float TileFactor;

out vec4 FragColor;

void main()
{ 
  
  vec4 BlendMapColor = texture(BlendMap, texCoord0);
  vec2 TiledTexCoords = texCoord0 * TileFactor;
  
  float BackTextureAmount = 1 - (BlendMapColor.r + BlendMapColor.g + BlendMapColor.b);
  vec4 BackGroundTextureColor = texture(Background, TiledTexCoords) * BackTextureAmount;
  vec4 RedTextureColor = texture(RedTexture, TiledTexCoords) * BlendMapColor.r;
  vec4 GreenTextureColor = texture(GreenTexture, TiledTexCoords) * BlendMapColor.g;
  vec4 BlueTextureColor = texture(BlueTexture, TiledTexCoords) * BlendMapColor.b;

  vec4 TotalColor = BackGroundTextureColor + RedTextureColor + GreenTextureColor + BlueTextureColor ; 

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
  
  FragColor = vec4(Diffuse, 1.0) * TotalColor + vec4(FinalSpecular, 1.0);
}