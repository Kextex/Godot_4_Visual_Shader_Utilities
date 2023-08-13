# Godot 4 Visual Shader Utilities
Godot Version Used: 4.2 dev3

## Directory structure:
| Directory | Description |
| --- | --- |
| **addons** | Contains custom visual shader nodes. |
| **environments** | Contains environment and camera attribute files. |
| **levels** | Contains generic levels. |
| **materials** | Contains common materials. |
| **shaders** | Contains common shaders. |
| **textures** | Contains common textures. |

## Contents:
---
 
- ### Desaturate
  **Preview:**  
  <img src="https://github.com/Kextex/Godot_4_Visual_Shader_Utilities/assets/114914897/ce7bb6c4-3359-46eb-b2c3-5a2728aede3d" alt="node" width="15%" height="15%">  

  **Description:**  
  Make color into grayscale.
  
  **Parameter:**  
  - **Amount:** Amount of desaturation..

---

- ### Flipbook
  **Preview:**  
  [YT Tutorial](https://youtu.be/Ccmso1cfEIA)  
  <img src="https://github.com/Kextex/Godot_4_Visual_Shader_Utilities/assets/114914897/05e852ac-4ee5-4739-9901-0fb64217813e" alt="node" width="15%" height="15%">  
  <img src="https://github.com/Kextex/Godot_4_Visual_Shader_Utilities/assets/114914897/bdab5b70-f9cb-4da7-9159-1fe73d4ae10c" alt="para" width="30%" height="30%">

  **Description:**  
  Create flipbook animation.
  
  **Parameter:**
  - **Speed:** Controls the playback speed. (It has no effect when "Particle Anim" is enabled. The speed and offset for animation control are determined by the "Speed" and "Offset" parameters in the ParticleProcessMaterial's Animation section.)
  - **Lerpframe Data:** Data used for interpolating frames.
  - **InvertX, InvertY:** Inverts the X or Y axis of the UV.
  - **Limit Frames:** Toggle playback range limitation.
  - **Max Frame:** Specifies the maximum frame when "Limit Frames" is enabled.
  - **Anim Loop:** Determines whether to loop the animation when reaching the end of frames.
  - **Particle Anim:** Toggle the shader for particle animation. If the material does not receive data from ParticleProcessMaterial, the animation will appear frozen.
  - **Number of Columns:** Sets the number of columns based on the sprite.
  - **Number of Rows:** Sets the number of rows based on the sprite.
  
  **Preview:**  
  <img src="https://github.com/Kextex/Godot_4_Visual_Shader_Utilities/assets/114914897/fe8ccc7b-46e3-4e84-aab6-1085e9516d56" alt="node" width="15%" height="15%">  
  <img src="https://github.com/Kextex/Godot_4_Visual_Shader_Utilities/assets/114914897/736aa3a1-3893-47d8-8172-355d0b472aa2" alt="para" width="30%" height="30%">

  **Description:**  
  Interpolate frames of flipbook animation utilizing flow map.
  
  **Parameter:**
  - **Lerpframe Data:** Receiving lerpframe data from Flipbook output.
  - **Albedo:** Albedo texture.
  - **Flow map:** Flow map texture.
  - **Albedo:** Modify albedo color.
  - **Enable Flowmap:** Toggle frame interpolation.
  - **Flow Strength:** The intensity of the flow map's influence.

---

## Demo Scenes:

  <img src="https://github.com/Kextex/Godot_4_Visual_Shader_Utilities/assets/114914897/9ec0f94c-2b26-4291-9063-1556e46f8d3c" alt="para" width="50%" height="50%">
