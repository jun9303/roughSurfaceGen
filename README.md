# roughSurfaceGen

An artificial rough surface generator based on the algorithm by Forooghi et al. (2017, *J. Fluids Eng.*, doi:10.1115/1.4037280). This tool enables the creation and visualization of rough surfaces for research and engineering applications.

**Usage:**  
- In MATLAB (tested on R2023b or later), run `roughSurfGenScript` to generate and plot a rough surface using your specified input parameters.
- To identify a rough surface that best matches prescribed roughness properties (Ra, Rq, Rsk, Rku, etc.) via heuristic optimization, run `genAlgOptScript`. This script leverages MATLAB’s genetic algorithm; see [How it works](https://www.mathworks.com/help/gads/how-the-genetic-algorithm-works.html) for more details.

This public repository accompanies our article, *"Flow in ribbed cooling channels with additive manufacturing-induced surface roughness."* Please see the link below for access to the publication.

## Associated Article

If you use the data or source code from this repository, please cite the following article:

- Lee, S., Baek, S., Ryu, J., Song, M., & Hwang, W. (2025). Flow in ribbed cooling channels with additive manufacturing-induced surface roughness. *Physics of Fluids*, 37(6), 065118. https://doi.org/10.1063/5.0268180

## How to Cite

To cite the code directly, click *Cite this repository* in the sidebar or refer to the metadata in `CITATION.cff`.