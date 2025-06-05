# roughSurfaceGen

An artificial rough surface generator based on the algorithm by Forooghi et al. (2017, *J. Fluids Eng.*, doi:10.1115/1.4037280). This tool enables the creation and visualization of rough surfaces for research and engineering applications.

**Features**
- Generate artificial rough surfaces using established algorithms.
- Visualize generated surfaces directly in MATLAB.
- Optimize surface parameters (Ra, Rq, Rsk, Rku, etc.) to match target roughness statistics using a genetic algorithm.

**Getting Started**
- **MATLAB Compatibility:** Tested on MATLAB R2023b or later.
- **To Generate and Visualize a Surface:**  
  Run `roughSurfGenScript` in MATLAB. You can specify input parameters to control the characteristics of the generated surface.
- **To Optimize Surface Properties:**  
  Run `genAlgOptScript` to find a rough surface that best matches your prescribed roughness properties. This script uses MATLAB’s genetic algorithm toolbox. For more details, see [How the genetic algorithm works](https://www.mathworks.com/help/gads/how-the-genetic-algorithm-works.html).

## Repository Purpose

This repository accompanies the article *"Flow in ribbed cooling channels with additive manufacturing-induced surface roughness."* For further details and results, see the publication linked below.

## How to Cite

If you use this code or data in your work, please cite:

- Lee, S., Baek, S., Ryu, J., Song, M., & Hwang, W. (2025). Flow in ribbed cooling channels with additive manufacturing-induced surface roughness. *Physics of Fluids*, 37(6), 065118. https://doi.org/10.1063/5.0268180

To cite the code directly, click *Cite this repository* in the sidebar or refer to the `CITATION.cff` file for citation metadata.