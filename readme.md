# Replication repository description for Nava, Ridley and Dall'Erba Agricultural Economics Forthcoming, *A model of the U.S. food system: What are the determinants of the state vulnerabilities to production shocks and supply chain disruptions?*

Correspinding author: [Noé J Nava](noe.nava@usda.gov).

**Goal:** Replicate the results in `Figure 1`, `Table 2`, and `Table 3` in the paper. 

*Note:* Our analysis is composed of two main procedures. In the first step, we employ a structural regression analysis derived from the gravity trade model based on the work of Eaton and Kortum (2002). The end goal of the previous exercise is to recover a trade elasticity value. Our results are reported in `Figure 1` and `Table 2`. The second step uses simulations and the trade elasticity value to study counterfactuals based on productivity shocks and supply chain disruptions. Our results are reported in `Table 3`.

### `Figure 1`: 

In `Figure 1`, we report the results from a gravity regression illustrated in `Equation 12`, where the left hand side describes the role of distance to determine normalized trade, and the right hand side describes the exporter and importer fixed effects. `code/fig1.do` is the script to replicate these figures. Notice that I am not sharing codes regarding the formatting of the table. Explanation of the regression is in the paper.

### `Table 2`:

In `Table 2`, we report the results from the regression illustrted in `Equation 13`, where the dependent variables are the fixed effects shown in `Figure 1`'s right panel. `code/tab2.do` is the script to replicate this table. Explanation of the regression is in the paper.

### `Table 3`:

In `Table 3`, we report the results from our two simulations that use `Equation 9` and `Equation 10`. Simulations are explained in the paper. Notice that you will need to install `GE_gravity_tech.ado` in Stata. Notice that I am just sharing the results of the simulations and not the scripts to exactly replicate the maps. `code/counterfactuals_estimation.do` is the script to replicate this table.
s

**How to cite this article:**

Nava, Noé J., Ridley, William C., and Dall'Erba, Sandy. Forthcoming in the Agricultural Economics. "A model of the U.S. food system: What are the determinants of the state vulnerabilities to production shocks and supply chain disruptions?"

A working paper can be found in [CREATE](https://create.ace.illinois.edu/files/2022/02/Nava_ridley_dallerba_CREATE.pdf).

