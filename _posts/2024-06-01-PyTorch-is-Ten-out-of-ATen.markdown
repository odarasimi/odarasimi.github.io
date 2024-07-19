---
layout: single
title:  "PyTorch is Ten out of ATen"
date:   2024-06-01 16:05:53 +0000
categories: Programming
sidebar:
  nav: "links"
---

*"I have made this letter **longer** than usual, only because I have not had the time to **make it shorter**." - Blaise Pascal*

For anyone with passing familiarity with deep learning workloads and the challenge of scaling, it is generally no surprise to see AI companies gathered at the cathedral of accelerated GPU hardware. Personally, I think domain-centric hardware could be the future, or perhaps compilers that support various backends, like XLA <https://openxla.org/xla>. 
Nevertheless, hand-woven optimization remains integral (no pun intended) in areas like geometry processing and deep learning.
These are some notes I took in an attempt to figure out C++ (and consequently CUDA) for PyTorch. They could perhaps be more concise, but brevity was sacrificed on the altar of clarity, and I hope they serve to aid understanding.

###### Motivation: ATen
ATen is a foundational library in the PyTorch ecosystem that provides the fundamental building blocks for tensor operations, memory management, and data types. Simply put - it powers crucial Pytorch operations. ATen is implemented in C++ and forms the **backend** for many PyTorch operations.

ATen also provides a set of optimized tensor operations that are written in C++, and these include element-wise arithmetic, matrix operations, reductions, etc. These low-level operations are used to build higher-level functions in PyTorch, meaning that many of the higher-level functions we use in PyTorch are powered by ATen. ATen also provides an abstraction layer for datatypes and hides the underlying details of the hardware (CPU, GPU, etc.) from higher-level PyTorch code. This allows PyTorch to run seamlessly on different hardware without extensive changes to the higher-level code.
ATen allows you to define custom C++ tensor operations that can be used within PyTorch, and thus tensor operations are highly optimized and designed for performance. 
This efficiency helps speed up deep learning computations, and this is what we will focus on.

###### PyTorch and ATen
PyTorch uses C++ extensively in its backend, and when one thinks of the relationship between PyTorch and ATen, there are 2 salient points to keep in mind

- When one performs tensor operations in PyTorch, the higher-level Python code often triggers ATen's C++ functions behind the scenes.
- These C++ functions are implemented to perform the actual mathematical computations, memory allocation, and some other low-level tasks required for tensor operations.

PyTorch's backend, including ATen, leverages C++ to provide efficient tensor operations, memory management, and hardware abstraction. When you execute PyTorch code involving tensor operations, the relevant C++ functions from ATen are used directly, without some separate compilation step to "ATen code." This is an orchestra of Python's high-level expressiveness and C++'s performance optimization.
So whenever we want to optimize our code with GPUs, we provide custom C++ code that we choose to call *C++ extensions* (using the ATen library directly for tensor computations), and we connect our familiar PyTorch frontend (Python) to our custom C++ code with python bindings (we have to connect the frontend to the backend ourselves, because they are custom)...as a consequence we have the option to reduce the overhead of the python interpreter (e.g fused operations).

**How do we do this?**
###### To Integrate C++ with PyTorch
- Write C++ Code: Write C++ code that contains the functionality needed.
- Compile C++ Code: The C++ code is compiled using a C++ compiler, the compiler generates machine code that can be executed by the CPU.
- Python Wrapper: Create a Python wrapper using tools like pybind11. This wrapper defines Python functions that map to the compiled C++ functions.
- Compile Wrapper: Now the Python wrapper code is compiled into a Python extension module.
- Python Interaction: When a Python function is called from the extension module, the Python interpreter uses the wrapper to call the corresponding compiled C++ function directly. This means that the compiled machine code of the C++ function is executed.
- C++ Execution: The compiled C++ code executes, performing the desired operations.
Return to Python: Control returns to the Python interpreter after the C++ function completes, and any results or return values from the C++ function are returned to Python.



###### C++ and PyTorch
**Ahead of Time with setuptools:**
- C++ Extensions: C++ extensions are modules that contain C++ code linked with Python, and allows use of compiled C++ functionality within Python.
- setuptools: setuptools is a package used to build and distribute Python packages. It includes tools for compiling and installing Python extensions.
- Building Ahead of Time: Building "ahead of time" means that we pre-compile C++ code into a shared library (like a .so file) before running the Python program.
- Process:
  - <span style="font-size:1.2em;">Write the C++ code and create a Python wrapper using tools like pybind11 or Cython.</span>
  - <span style="font-size:1.2em;">Use setuptools to build the C++ extension into a shared library. This compiled extension module can then be imported and used in the Python code like any other Python module.</span>

**Just in Time with torch.utils.cpp_extension.load():**
- C++ Extensions: Same as above, C++ extensions are modules containing compiled C++ functionality.
torch.utils.cpp_extension.load(): This is a PyTorch utility function that allows one to compile and load C++ extensions dynamically at runtime, rather than pre-compiling them before running the Python program.
- Building Just in Time: With this approach, we don't pre-compile the C++ extension ahead of time. Instead, we use torch.utils.cpp_extension.load() to compile and load the extension when needed.
- Process:
  - <span style="font-size:1.2em;">Write the C++ code and create a Python wrapper.</span>
  - <span style="font-size:1.2em;">Use torch.utils.cpp_extension.load() to compile the C++ code and load the extension module dynamically into the Python program at runtime. This extension module is then available for use in the Python code.</span>



Ultimately, we can then mix C++ with CUDA kernels (which run on the GPU). The compilers for both C++ AND CUDA each handle their respective pieces of code…and as usual each function is accessible from the Pytorch python frontend.


###### *References*
- <https://pytorch.org/tutorials/advanced/cpp_extension.html>
