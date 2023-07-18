# Godot 4 Visual Shader Utilities
Godot Version Used: 4.1 stable

## Directory structure:
| Directory | Description |
| --- | --- |
| **addons** | Contains custom visual shader nodes. |
| **levels** | Stores generic levels. |
| **materials** | Stores common materials. |
| **shaders** | Stores common shaders. |
| **textures** | Stores common textures. |

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
  <img src="https://github.com/Kextex/Godot_4_Visual_Shader_Utilities/assets/114914897/17b5a619-355a-44fc-ac9d-c8faaa35181f" alt="node" width="15%" height="15%">  
  <img src="https://github.com/Kextex/Godot_4_Visual_Shader_Utilities/assets/114914897/bdab5b70-f9cb-4da7-9159-1fe73d4ae10c" alt="para" width="30%" height="30%">

  **Description:**  
  Create flipbook animation.
  
  **Parameter:**
  - **Speed:** Controls the playback speed. (It does not have any effect when "Particle Anim" is enabled. The speed and offset for animation control are determined by the "Speed" and "Offset" parameters in the ParticleProcessMaterial's Animation section.)
  - **InvertX, InvertY:** Inverts the X or Y axis of the UV.
  - **Limit Frames:** Enables the playback range limitation.
  - **Max Frame:** Specifies the maximum frame when "Limit Frames" is enabled.
  - **Anim Loop:** Determines whether to loop the animation when reaching the end of frames.
  - **Particle Anim:** Enables the shader for particle animation. If the material does not receive data from ParticleProcessMaterial, the animation will appear frozen.
  - **Number of Columns:** Sets the number of columns in the sprite.
  - **Number of Rows:** Sets the number of rows in the sprite.
