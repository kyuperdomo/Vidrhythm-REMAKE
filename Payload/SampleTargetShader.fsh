//
//  Shader.fsh
//  Ions
//
//  Created by Douglas Applewhite on 4/5/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
precision mediump float;

varying lowp vec2 textureVarying;

uniform sampler2D u_texture;

uniform float u_fAlpha;
uniform int u_iHasMask;
uniform sampler2D u_texMaskTexture;

#ifdef RGB_BLEND
uniform vec4 u_vecRgbBlendColor;
uniform float u_fRgbBlendMix;
#endif // RGB_BLEND

#ifdef COLORIZE
uniform vec4 u_vecRgbColorizeColor;
#endif // COLORIZE

#ifdef HORIZONTAL_DISPLACE
uniform float u_fHorizontalDisplaceMagnitude;
#endif // HORIZONTAL_DISPLACE

#ifdef LEVELS
uniform float u_fLevelsBrightness;
uniform float u_fLevelsContrast; // this gets a partially precomputed value
#endif // LEVELS

#ifdef USES_NOISE_TEXTURE
uniform sampler2D u_texNoiseTexture;
#endif // USES_NOISE_TEXTURE

#ifdef USES_SAMPLE_TIME
uniform float u_fSampleTimeSeconds;
uniform float u_fSampleDurationSeconds;
uniform float u_fSampleTimePercent;
#endif // USES_SAMPLE_TIME

void main()
{
   vec2 samplePos = textureVarying;
   
#ifdef HORIZONTAL_DISPLACE
   vec2 noiseSamplePos = vec2( 0, textureVarying.y );
   float offset = texture2D( u_texNoiseTexture, noiseSamplePos ).r - 0.5;
   float mix = 1.0 - smoothstep( 0.0, 0.3, u_fSampleTimePercent );
   samplePos.x += mix*offset*u_fHorizontalDisplaceMagnitude;
#endif // HORIZONTAL_DISPLACE

   float maskAlpha = 1.0;
   if ( u_iHasMask == 1 )
   {
      vec4 maskColor = texture2D( u_texMaskTexture, samplePos );
      maskAlpha = maskColor.r;
   }
   
   gl_FragColor = texture2D( u_texture, samplePos );
   
#ifdef LEVELS
   if ( u_fLevelsBrightness < 0.0 )
   {
      vec4 mult = vec4( 1.0 + u_fLevelsBrightness );
      gl_FragColor *= mult;
   }
   else
   {
      vec4 mult = vec4( 1.0 ) - gl_FragColor;
      gl_FragColor += mult*vec4( u_fLevelsBrightness );
   }
   
   vec4 contrastMult = vec4( u_fLevelsContrast );
   gl_FragColor = contrastMult*( gl_FragColor - vec4( 0.5 ) ) + vec4( 0.5 );
#endif

#ifdef RGB_BLEND
   gl_FragColor = mix( gl_FragColor, u_vecRgbBlendColor, u_fRgbBlendMix );
#endif // RGB_BLEND
   
#ifdef COLORIZE
   float luma = 0.3*gl_FragColor.r + 0.59*gl_FragColor.g + 0.11*gl_FragColor.b;
   gl_FragColor.rgb = luma*u_vecRgbColorizeColor.rgb;
#endif // COLORIZE
   
   gl_FragColor.a = u_fAlpha*maskAlpha;
}
