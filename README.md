# ConvexOptimization Solver

This is an optimization routine implemented in MATLAB for solving convex optimization problems. This solver was built as an educational exercise while studying the references cited, and auditing the course Advanced Robotics (CS287) by UC Berkeley. The code is heavily commented.


We solve the problem assuming convex objective function, linear equality constraint, and convex inequalities. The solver assumes twice differentiability in the function domains. 

<p align="center">
  <img src="https://github.com/sritee/ConvexOpt-Interior-Point-Method/blob/master/unconstrained_trajectories_visualize/GradientDescent_backtracking.jpg" width="350" title="hover text">
  <img src="https://github.com/sritee/ConvexOpt-Interior-Point-Method/blob/master/unconstrained_trajectories_visualize/NewtonMethod_backtracking.jpg" width="350" alt="accessibility text">

Comparison of Gradient Descent and Newton's method, both equipped with backtracking line search on an unconstrained problem.
</p>


<p align="center">
<b>HOWTO</b>
</p>


**References** - 1) Convex optimization by Boyd and Vandenberghe.
             2) Numerical Optimization by Nocedal and Wright.
             
Solutions were verified for multiple problem instances with **CVX**. Set variable CVX_check = 'ON' if you have CVX installed and want to verify your solution. 

We use a feasible start path following algorithm, with a log barrier function. Newton's descent, with backtracking line search for the step size choice is used. 

TODO: Extend to solve general semi-definite programs as currently, objective and inequalities involve functions over the real numbers.


             
   
