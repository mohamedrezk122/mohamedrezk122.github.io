---
layout: post
title: My OS & System tools
author : Mohamed Rezk
permalink: /system
date: "march,2,2023"
---

In this post, I am going to list some of the programs and tools I use on daily basis. I use GNU/LINUX as the daily driver operating system. The reason I use such system is about one crucial concept called "Extensibility"; meaning, you can extend your system up to the hardware capability not just what the software vendor offers you, which is the case in Windows-based systems. Also, there are other motives why people might use UNIX-like systems (BSD, LINUX), like security and being open-source, any bug or mis-behaviour can be easily fixed through community contributions, so there is no need to wait for an update. 

**For more about OSes:**

[Video] [anaHr: History of Operating Systems](https://www.youtube.com/watch?v=fxXGLMPJnFQ&t=2192s)

[Video] [anaHr: My choice of OS](https://www.youtube.com/watch?v=z1-yuolwrVs)



## Operating System
<img src="\assets\images\system\void.png"  style="float: right; max-width: 30%;" />

I use [**Void Linux**](https://voidlinux.org/) as a Linux distribution since August-2022 , before that I was using Ubuntu with Gnome. 
Void Linux is a lightweight, fast, and flexible Linux distribution that offers several advantages over other popular distributions. Here are some reasons why I see Void Linux is so awesome:

Rolling Release: Void is continuously updated with the latest packages and software. This ensures that you always have access to the latest and greatest features and security patches without having to reinstall the operating system over and over again.

Simplicity: Void Linux has a simple and minimalist design that is easy to use, with a clean and well-documented package manager. Also Void uses **runit** as an init system, which is so fast and minimal unlike something like **SystemD** (very bloated and slow). 

Overall, Void Linux offers an excellent combination of speed, simplicity, customization, and security that makes it a great choice for both desktop and server environments.

**For more:**

[Video] [anaHr: My System-Void Linux & Suckless](https://www.youtube.com/watch?v=iLTViIipsw8&t=1003s)
[Article] [unixsheikh: Void Linux - a great and unique Linux distribution](https://unixsheikh.com/articles/void-linux-a-great-and-unique-linux-distribution.html)

## Window Manger

### Why a window manager ?!

For me, the ultimate choice for the tiling window manager depends on how the windows are tiled (tiling algorithm). There are several tiling algorithms such as binary tree, fibonacci, spiral, stack and master, and so on. However, for some folks, the language the window manager is written and configured in might be the scene player. For instance, people who is fond of C may end up using dwm, as it is minimal and configured in C, others who love python may end up using something like qtile, xmonad for Haskell enthusiasts and so on. To be honest, this is not very important for me, at least not at the moment. The reasoning behind such opinion, is that you should not configure your window manager that often, it suffices to do it once or twice and stick to it. Such opinion drives the motivation of using "compiled-configuration" window managers like dwm, dwl (dwm for wayland). Basically, dwm relies on the "patch-to-add-feature" model i.e. if you want some feature say X, you have two options either implement it in C, and publish that patch for others to use, or finds if someone had already done that jargon. Either way, it seems not very beginner-friendly to configure dwm especially that fact of re-compiling and logout to see the effect , unless you like someone's configuration and decide to stick with it. Here comes my top choice for tiling window managers, i3wm.     
<img src="\assets\images\system\i3wm.png" style="float: right; max-width: 30%;"/>



**For more:**

[Video] [Tiling window algorithms](https://www.youtube.com/watch?v=Api6dFMlxAA)
