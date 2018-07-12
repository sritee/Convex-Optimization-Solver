# ConvexOptimization Solver

This is an optimization routine implemented in MATLAB for solving convex optimization problems. This solver was built as an educational exercise while studying the references cited, and auditing the course Advanced Robotics (CS287) by UC Berkeley. The code is heavily commented.


We solve the problem  ![codecogseqn](https://user-images.githubusercontent.com/25884784/42663198-32ed22b4-8652-11e8-9e7c-89459932a2b7.gif)

**References** - 1) Convex optimization by Boyd and Vandenberghe.
             2) Numerical Optimizatio by Nocedal and Wright.
             
Solutions were verified for multiple problem instances with **CVX**. Set variable CVX_check = 'ON' if you have CVX installed and want to verify your solution. 

We use a feasible start path following algorithm, with a log barrier function. Newton's descent, with backtracking line search for the step size choice is used. 

TODO: Extend to solve general semi-definite programs, as currently, equalities, objective and inequalities involve real numbers.


             
   
