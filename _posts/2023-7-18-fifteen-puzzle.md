---
layout: post
title:  "The Fifteen Puzzle"
author: "Mohamed Rezk"
image: fifteen-puzzle.webp
keywords: artificial intelligence, informed search, math puzzles, group theory
---

Looking at the 15 puzzle from a mathematician and computer scientist scope.

## Prerequisites

The article is nearly self-contained, but a background in these topics would be certainly helpful:
- basic permutation concepts 
- some understanding of algorithms and complexity analysis 

## Introduction

The 15 puzzle is a simple sliding puzzle  composed of 15 numbered squares labelled from 1 to 15 and one empty/blank square (will be labelled as 16 to ease the computations and analysis), which all placed in a $4\times4$ box . The rule is simple: given an initial configuration $C$ , we have to reach  a goal configuration $C'$ (if feasible) by applying series of  "valid" moves.  A valid move involves swapping  the empty square with one of its neighbors (up,down,left,right).  

Throughout this article, we are going to explore how to determine if a certain goal configuration reachable or unreachable given some starting arrangement. Additionally, we will try to generalize the puzzle for any size, and see if this generalization will help us understand the puzzle better and estimate a complexity metric (number of moves) to reach a certain configuration, if applicable. Finally, we will examine if we can solve the puzzle using a structured algorithm, and identify techniques that can speed up the execution time.   

## History and problem formulation

The puzzle was originally invented by **Noyes Palmer Chapman** in 1874, but it was misattributed to **Sam Loyd**. In reality, Sam had nothing to do with creation of the puzzle. He attempted to claim credit for it and fought for recognition, a battle that lasted for 20 years from 1891 until his death in 1911. Loyd even offered a prize ($1000) to anyone who could  solve a certain instance defined by him.  
The starting state is, all the squares are in the right place except for 14 and 15 being swapped.  The desired  goal is to swap them back, thus returning  every square to its respective place. This why the puzzle is known as  the 14-15 puzzle .  The following two figures can help illustrate the problem definition more meaningfully.

<div style="text-align:center">
  <img src="\assets\images\post-2\14-15.webp" />
  <div class="caption">Loyd Puzzle</div>
</div>

Sadly, no one took the prize as the goal is unreachable !  

## Parity Proof

To determine whether the puzzle is solvable from some initial state to another goal state, we need to develop a mathematical formulation that provides a solid and intuitive analysis.  

In the realm of abstract algebra and group theory, a transposition (or a 2-cycle) is the simplest permutation that can be obtained. The transposition process is denoted as tuple of two numbers, such as:
$$(1 \ \ \ 2)$$
This means that the element 1 is swapped with 2, while leaving other elements in the set unchanged. Any complex cycles or permutations applied to a group or  structure can be further decomposed into several simple transpositions. It is important to note that the set of transpositions obtained from this decomposition is not unique, meaning multiple  sets of transpositions can generate the same final configuration. 
This argument is justified by the notion of the parity of the permutation. Suppose we have a permutation $P$  composed of $n$ transpositions then $P$ can be expressed as:

$$
\begin{equation}
\tag{1}
P = t_n \ t_{n-1}\ .. t_1=\prod_{i=n}^{1} t_i
\end{equation}
$$

Side note:  the compositions are applied from right to left, but they are also associative. 
Now, let's take a step backward and understand "what is a group ? " The most basic and informal definition of a group is: a group $G$  is a non-empty set closed under a binary operation $\ast$, and has an identity element $e$.  For every  element in the set, there must exist an inverse . Consider $\mathbb{Z}$  the set of integers : 

$$\mathbb{Z} = \{...,-2,-1,0,1,2,...\}$$

$\mathbb{Z}$ is closed under addition, which means that you can take any two numbers in the set, add them together, and the result will also be  in $\mathbb{Z}$. Also, every member $a$ in the set has its own inverse $a^{-1}$, when they are added together, an identity element is obtained, which in this case is 0.   

At this moment we can proceed with the proof. With equation $(1)$, we can get the inverse of $P$ by applying the transpositions in the opposite order. 

$$
\begin{equation}
P^{-1} = t_1 \ t_{2}\ .. t_n=\prod_{i=1}^{n} t_i
\end{equation}
$$

$$
\begin{equation}
\tag{2}
P^{-1}*P = t_1 \ t_{2}\ .. t_n \ t_n \ t_{n-1}\ .. t_1
\end{equation}
$$

Since the operation on the group is associative you can rewrite equation $(2)$ this way : 

$$
\begin{equation}
P^{-1}*P = (t_1 \ (t_{2}\ .. (t_{n-1}\ (t_n \ \ t_n) \ t_{n-1} \ )\ .. t_2 \ ) \ t_1)
\end{equation}
$$

This means that we apply a  swap of two elements and then undo the change; the whole process leaves us the with set unchanged or, more closely, with the identity $e$ .

$$
\begin{equation}
P^{-1}*P = (t_1 \ (t_{2}\ .. (t_{n-1}\ (t_n \ \ t_n) \ t_{n-1} \ )\ .. t_2 \ ) \ t_1) = e = P*P^{-1} 
\end{equation}
$$

Clearly, you can see the relation  between identity and even operations. This means that in order to obtain the original/unchanged form of the set, you have to apply each transpositions and its inverse,  leading to even number of operation,  whether $n$ is even or odd (even + even is even, and odd+odd is even). This is a crucial point and will help us identify the unsolvable states of the puzzles. 

As we mentioned before, any complex permutations can be decomposed into multiple smaller transpositions, and their number is not fixed but their parity (even/odd) is. Let us consider this small example where we want to go from the left configuration to the right one with smallest number of transpositions : 

$$(1 \ \ 2 \ \ 3)  \ \ \longrightarrow (3 \ \ 2 \ \  1)$$

The clear answer is swapping 1 with 3 , or in a formal way, applying the transposition $(1 \ 3)$.  Of course, we can  add unnecessary steps an their inverses (even number of transpositions) and still get the same result. However, it is important to note that the parity of the number of transpositions is fixed, odd in this case, as you add even to odd and the result is also odd. A similar argument can be made for cases with even number of transpositions. What is impossible is applying n or m  transpositions and get the same result knowing that n is even and m is odd.

To sum up , what is needed to be known just these two facts:

- **FACT 1** : the parity of a permutation is fixed . 
- **FACT 2** : the parity of identity is even. 

Enough of abstract algebra;  now we begin solving the puzzle. First, we flatten the board,  commonly known as hot vector.  For example, consider this instance of the puzzle, which is flattened, with the solved/goal state at top and the scrambled one beneath it.  Here is a sample made for the 8 puzzle for simplification: 

<div style="text-align:center">
  <img src="\assets\images\post-2\flatten.webp" />
  <div class="caption">8-puzzle instance with its flattened version</div>
</div>

$$
\begin{pmatrix}
1 & 2 & 3 & 4 & 8 & 6 & 7 & 9 & 5 \\
9 & 2 & 3 & 1 & 4 & 6 & 7 & 8 & 5 \\
\end{pmatrix}
$$


Recall the instance of the puzzle proposed by Loyd; these are their respective flattened versions.

$$
\begin{pmatrix}
1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & 10 & 11 & 12 & 13 & \boxed{14} & \boxed{15} & 16\\
1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & 10 & 11 & 12 & 13 & \boxed{15} & \boxed{14} & 16\\
\end{pmatrix}
$$

To reach the goal state, the only transposition that needs to be applied is :

$$(14 \ \ 15) \ \ \ \longrightarrow\ \ \ | \ \{ \ (14 \ \ 15) \ \} \ | =  1  \ \ \ \equiv 1\pmod{2}$$

Hence the parity of this permutation is **ODD**.  Now let's put some focus on the empty square. The blank square is the main character in the scene as it is the only square guaranteed to propagate across the box. Clearly, you can see that the blank square (16) is in its right place in both configurations, which means that every operation and its inverse has been applied to that particular square. In a formal way, the number of moves to the right equals the number of the moves to the left, and similarly with up and down.

$$P = L + R + U + D = 2R +2U = 2 \ (R+U) \equiv 0 \pmod 2$$

This shows that the parity of the permutation is **EVEN**, which is further confirmed by the parity of identity (the square returned to its original place ) that is also **EVEN** (according to fact 2). 
So, based on **FACT 1**, there is a contradiction in the parity of the permutation, and this instance of the puzzle is not solvable . Hence, no one got the chance to win the $1000 prize. 

You can follow a similar argument to state whether the puzzle is solvable or not by counting the number of the transpositions needed for the initial state to reach the final one, and hence the parity, which is then compared to the parity of blank square, simply obtained by counting the number of moves vertically and horizontally to reach its final destination. This is known in computer science as the **Manhattan Distance**. 

This might be a cranky and not that well-written proof, but I hope somehow you get the idea.  

## Generalization

The fifteen puzzle is just one instance from the family of  ($n^2-1$) puzzles, where $n \ge 3$. This can be generalized even further with ($p\times q-1$), where $p$ and $q$ are the dimensions of the rectangular box of interest.  The number of possible configurations in the puzzle state space $S$ is, therefore:

$$|S| = \frac{(pq)!}{2}$$

But why not just $(pq)!$ ? The catch is that only half of them is solvable/ reachable given a start state. That is due to the parity of the permutation / transpositions we discussed earlier. More clearly, odd permutations are exactly half the state space, as are the even ones.  So, for the 15 puzzle, there are:

$$\frac{16!}{2} = 10,461,394,944,000 \approx 1.04\times 10^{13}$$

solvable configurations, or one can say  nodes in the search tree, where the root is the starting configuration and the goal is hanging out there at some depth $d$.  The search space for the 15 puzzle is very large to grind or brute force. Even if we managed to do that on very fast computer, we cannot handle the very next instance like the 24 puzzle. The nature of the puzzle is exponential, so we have to be sufficiently clever about the methods we use to speed the computation dramatically.

Generalizing the problem let us understand the nature of the computational aspect of the puzzle. For instance, what search algorithm we might use, or what heuristic function we have to alter to suit the problem, etc. 

## Algorithmic approach

Now, with the interesting part. In this section of the article, we are going to develop a way to solve the puzzle (if is solvable).  As we mentioned in the previous section, we can model the problem as a tree, where each node represents a configuration obtained by swapping the blank square with one of its neighbor tiles.

<div style="text-align:center">
  <img src="\assets\images\post-2\tree.webp" />
  <div class="caption">simple puzzle tree </div>
</div>

Furthermore, the number of nodes in such tree is huge and exponentially increases with the problem size. Therefore, using ordinary (uninformed) search methods like breadth-first, depth-first, or iterative-deepening depth-first will not work efficiently as we expect. In fact, breadth-first search can work well in small instances like the 8 puzzle where the goal node is shallow (at a small depth), considering that the average branching factor is 3. One can compute it by counting the possible states we can reach at distinct positions within the box.  For instance, we have 3 moves available if the blank square at the border but not at the corner, 2 moves at the corner, and 4 moves at the center of the box, which gives an average branching factor of 3:  

$$\bar{b} = \frac{3 + 2 +4}{3} = 3$$

However, using breadth-first  with highly scrambled puzzle (deeper solution) with a depth 30 will produce a huge number of nodes $O(b^d)$ that the algorithm has to expand before reaching the goal. Additionally, space complexity is so bad with $O(b^d)$. Similar arguments can be made for the rest of uninformed methods. Uninformed search algorithms have no idea about the nodes they are expanding; in other words, they do not know how far the goal is, which make them waste a lot of time and memory in useless nodes. This is where  informed methods come to into play. These algorithms know a little bit about the problem more than just the definition, for example the nature of state space. The problem space can be a grid, a sphere,  or just flat land. With that in mind, we can choose a proper heuristic function that could estimate the how far the goal is from the current node. But shall we choose the algorithm first ? I think you guessed it already, A*.  

### A* Algorithm

A* belongs to best-first search algorithms class, which uses an evaluation/cost function $f(n)$ to expand the nodes based on lowest value of $f$. Dijkstra/uniform-cost search uses just the path cost as an evaluation function $f(n) = g(n)$ , and greedy best-first search uses just the heuristic $f(n) = h(n)$. On the other hand, A* uses the combination of both:

$$
\begin{equation}
\tag{3}
f(n) = g(n) + h(n)
\end{equation}
$$

where $h$ indicates what is the estimated remaining distance to reach the goal, while $g$ is the distance traveled from the root to the current node.

A* is both optimal (no better solution exists) and complete (yields the solution if there is one) as long as the heuristic function is admissible and consistent. Admissible heuristic means that the heuristic function is optimistic or never overestimates the actual remaining distance to goal ($h^\ast(n)$) . More formally, we have, 

$$h(n) \le h^\ast(n)$$

Consistency/Monotonicity means the heuristic function satisfies the triangle inequality, 

$$
\begin{equation}
\tag{4}
h(n_1) ≤ c(n_1 \rightarrow n_2) + h(n_2).
\end{equation}
$$

This inequality ensures that the $f$ values are non-decreasing along the path. Here is a simple direct proof :

$$
\begin{align*}
f(n_2) & = g(n_2) \ + \ h(n_2) &\\
&= c(n_1 \rightarrow n_2) \ + \ g(n_1) + h(n_2) &  \\
& \ge h(n_1) \ + \ g(n_1) & \\
& \ge f(n_1) &   \square 
\end{align*}
$$

### Iterative Deepening A*

 Looking at its space complexity, however,  A* is not that memory-efficient as it stores every node in the operation data structure which is usually some implementation of priority queue. The previous behavior is useful in pruning the duplicate nodes; however, the space complexity is going to grow exponentially with the problem description,  $O(b^d)$.  We have to look for another variant with the  completeness and optimality of  A* i.e IDA*. Iterative deepening A* algorithm is very similar to iterative deepening depth-first, except it uses the $f$-values as the bound. Simply, it begins with the heuristic of the root as the bound and  for every child of the root, it explores the grandchildren if the child $f$-value is less than or equal the bound. If this iteration does not find a solution, we update the bound with the minimum $f$-value of the children, and search again.  This can be summarized with the following Wikipedia pseudo-code:
 
``` lua
function ida_star(root)
    bound = h(root)
    path  = [root]
    loop
        t = search(path, 0, bound)
        if t = FOUND then return (path, bound)
        if t = inf then return NOT_FOUND
        bound = t
    end loop
end function

function search(path, g, bound)
    node = path.last
    f = g + h(node)
    if f > bound then return f
    if is_goal(node) then return FOUND
    min = inf
    for succ in successors(node) do
        if succ not in path then
            path.push(succ)
            t = search(path, g + cost(node, succ), bound)
            if t = FOUND then return FOUND
            if t < min then min = t
            path.pop()
        end if
    end for
    return min
end function
```

The advantage in using IDA* is the space complexity is linear with problem description, as it only store the nodes  in the current path, as opposed to the naive A* which additionally stores the unexplored nodes. However, this makes the IDA* algorithm slower as there are many duplicate nodes due to symmetry in the puzzle, which, in turn increases the processing time.    
   
### Heuristic Assessment

In order to choose the proper heuristic function, we have to develop a metric to assess the function against. But first, we have to take a closer look at the run time complexity of A* algorithm. The time complexity of A* can be treated the same way BFS $O(b^{\alpha d})$, where $\alpha = 1$ in case of BFS  and $\alpha = \epsilon$  in case of A*  . Luckily, $\epsilon$  has a name, heuristic relative error: 

$$\epsilon = \frac{h^\ast - h}{h^\ast}$$

$$0\le \epsilon \le 1$$

That is because A* does not expand all of the nodes in a certain level, only  the promising ones, as opposed to BFS. Rearranging the big O term, we obtain,

$$O((b^\epsilon)^d) = O({b^{\ast}}^d) $$

where $b^\ast$ is the effective branching factor. This is the metric we are looking for, a perfect heuristic function makes $\epsilon$ tend to 0, which makes $b^\ast=1$, while the worst heuristic makes $\epsilon$ tend to 1, and we revert to BFS. The effective branching factor ($b^\ast$) is simply the branching factor a uniform tree would have at that solution depth and can be easily computed by this approach given the number of expanded nodes $N$ to reach the goal and the solution depth $d$,

$$
\begin{align*}
N+1 & = 1 + b^{\ast} +  {b^{\ast}}^2 +  \  ... \ + {b^{\ast}}^d \\
&= \sum_{i=0}^d \ ({b^{\ast}})^i \\
&= \frac{(b^{\ast})^{d+1} - 1}{b^{\ast}-1}
\end{align*}
$$

which can be solved with some iterative algorithm like Newton-Raphson. 

### Heuristic functions

Heuristic functions are generated from the relaxed version of the problem. The relaxation graph is a super-set of the search tree/graph obtained by removing certain constraints from the original problem, like tiles cannot slide over each other. In this case, more edges are being added to the graph, making the process of finding the goal is much easier. For instance, in the generalized ($pq$)-puzzle, if we have two tiles $X$ and $Y$ , we have the following  constraint defined:
- $X$ can move to $Y$ if $Y$ is a neighbor (horizontal or vertical) to $X$ and $Y$ is blank 
This can be broken down into 3 relaxed versions as follows,

1 -  $Y$ is adjacent to X , where Y may not be blank 

2 -  $Y$ is blank, where Y may not be adjacent to $X$

3 -  Neither: $X$ can move to Y, where Y may not be blank or adjacent to $X$ 

From these relaxations, we can deduce the heuristic functions . For example, the first case is the **Manhattan distance**, while the second one is called **Gaschnig Heuristic**, and the last relaxation produces the **Hamming distance** or **Misplaced tiles**.  The Hamming distance is the least descriptive heuristic. Gaschnig is at least as good as the Hamming distance, and even can be better than the Manhattan distance, which is  superior.

Manhattan distance alone is not enough in some case as it might be off the actual remaining distance (not admissible enough), which leads the algorithm to explore more nodes than needed. This is because Manhattan distance does not know about the interaction between the tiles. One way to overcome such a problem is using correction algorithms beside the Manhattan distance, like **Linear conflict**, and **Corner tiles**. These methods looks for specific cases and correct the Manhattan distance value by adding some offset depending on how much correction is needed.  
  
## Further Optimization

In the process of testing the algorithm, I experienced the true slowness of the IDA* algorithm (due to duplicate nodes). For example, this random instance of the 15-puzzle with plain Manhattan distance has these timing information:

$$
\begin{bmatrix}
15 & 16 & 14&  13\\
1  & 3 &  2 &  4\\
7  & 8 &  6&   5\\
11 & 9&  10  &12 \\
\end{bmatrix}
$$

|edit| runtime(s) | neighbor time(s)  | depth  | expanded nodes  |
|---|---|---|---|---|
|  vanilla |  261.1907 | 130  | 51  |  7,530,405 |
| with duplicate nodes lookup tables  | 110.2581  |  41.63  | 51  |  7,530,405 |
|  implementing the static weighted cost function WIDA* with $W_h/W_g=81/19$ |   0.3435|   0.1750 | 165  |  12,536 |

The dramatic speed-up in the execution time is due to non-monotonicity and non-admissibility of the cost function, which in turn, make the algorithm pessimistic, and will not generate the optimal solution but a longer one. The weights can be tweaked to get some trade off between the optimality and runtime.   


## Demo

For the sake of completeness, I have made a simple Manim visualization.
<div style="text-align:center">
  <img src="\assets\images\post-2\demo-opt.gif" />
  <div class="caption">Demo</div>
</div>

## TODO

As for now, I am satisfied with the heuristic functions and the IDA* algorithm discussed. But from time to time, I will implement algorithms like A* , Bidirectional A* and other variants with different heuristic functions imposed by a correction methods and test different cases. Also, it might be a good idea to implement pattern databases. This might happen in the project GitHub repo, as this article is never intended to serve the implementation this far.

## References

**GitHub repo** : [https://github.com/mohamedrezk122/fifteen-puzzle-solver](https://github.com/mohamedrezk122/fifteen-puzzle-solver)

[(Book) Artificial Intelligence: A Modern Approach ](https://people.engr.tamu.edu/guni/csce421/files/AI_Russell_Norvig.pdf)

[(Video) Why is this 15-Puzzle Impossible? - Numberphile](https://www.youtube.com/watch?v=YI1WqYKHi78&t=1237s&pp=ygURMTUgcHV6emxlIHByb2JsZW0%3D)

[(Paper) Linear-space best-first search](https://www.sciencedirect.com/science/article/abs/pii/000437029390045D)

[(Paper)Finding optimal solutions to the twenty-four puzzle](https://courses.cs.washington.edu/courses/csep573/10wi/korf96.pdf)

[(Paper) Pruning duplicate nodes in depth-first search](https://cdn.aaai.org/AAAI/1993/AAAI93-113.pdf)

