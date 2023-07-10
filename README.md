# Godot 4 Visual Shader Utilities

## Directory structure:
| Directory | Description |
| --- | --- |
| **addons** | Contains custom visual shader nodes. |
| **levels** | Stores generic levels. |
| **shaders** | Stores common shaders/materials. |
| **textures** | Stores common textures. |

## Contents:
---

- ### Desaturate
  **Description:**  
  Make color into grayscale.
  
  **Parameter:**  
  - **Amount:** Amount of desaturation..

---

- ### Flipbook
  **Preview:**  
  [YT Tutorial](https://youtu.be/Ccmso1cfEIA)
  
  **Description:**  
  Create flipbook animation.
  
  **Parameter:**
  - **Speed:** Controls the playback speed.
  - **InvertX, InvertY:** Inverts the X or Y axis of the UV.
  - **Limit Frames:** Enables the playback range limitation.
  - **Max Frame:** Specifies the maximum frame when "Limit Frames" is enabled.
  - **Anim Loop:** Determines whether to loop the animation when reaching the end of frames.
  - **Particle Anim:** Enables the shader for particle animation.
  - **Number of Columns:** Sets the number of columns in the sprite.
  - **Number of Rows:** Sets the number of rows in the sprite.
