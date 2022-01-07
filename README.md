   # Primal Interior Point method with feasible start

This is an optimization routine implemented in MATLAB for solving convex optimization problems. This solver was built as an educational exercise while going through the material in the references. 


We solve the problem assuming convex objective function, linear equality constraint, and convex inequalities. The solver assumes twice differentiability in the function domains. 

<p align="center">
  <img src="https://github.com/sritee/ConvexOpt-Interior-Point-Method/blob/master/unconstrained_trajectories_visualize/GradientDescent_backtracking.jpg" width="350" title="hover text">
  <img src="https://github.com/sritee/ConvexOpt-Interior-Point-Method/blob/master/unconstrained_trajectories_visualize/NewtonMethod_backtracking.jpg" width="350" alt="accessibility text">

Comparison of Gradient Descent and Newton's method with backtracking line search on an unconstrained problem.
</p>


<p align="center">
<b>Get Started</b>
</p>
   
  The function fi in main.m encodes the objective function and the inequalities. fi{1} is the objective function, and fi{2} onwards are the inequality function g_i{s}. The equalities should be encoded in the matrix C and vector d, such that C*x=d. Three function with box constraints have been provided for starters. main.m first calls Phase 1 method, for finding a strictly feasible starting point. This then calls Phase2, the newton's descent with backtracking line search. Solutions were verified for multiple problem instances with CVX. Set variable CVX_check = 'ON' if you have CVX installed and want to verify your solution. 



<p align="center"> 
   <b>References</b>
   </p>
   
 * https://people.eecs.berkeley.edu/~pabbeel/cs287-fa13/ (starter code in an assignment used to bootstrap this repo)
  * Convex optimization by Boyd and Vandenberghe
  * Numerical Optimization by Nocedal and Wright.

             

<p align="center"> 
   <b>TODO</b>
   </p>

* Extend it to solve general semi-definite programs as, currently, inequalities are w.r.t the non-negative orthant. 
* Handle non-differentiablity using methods like Proximal-Newton.


             
   
