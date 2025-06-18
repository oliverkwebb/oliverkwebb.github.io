---
title: "ADT, by any Other Name"
date: 2025-05-31T17:27:56-05:00
draft: true
---

* ADT is based off two building blocks
* "And"
 * Product Type
 * Cartesian Product
 * Catt Comm Dia
  * Think of the flow of information
  * Can be used to construct an A or a B
* "Or"
 * Sum Type
 * Union
 * Catt Comm Dia
  * Think of the information
  * Can be constructed from either an A or B

# Regex

* What is a regex *really*?
* https://swtch.com/~rsc/regexp/regexp1.html
* Product type is just a normal sequence
* Sum type is \[character range\] or (a|b|c)

## scanf is a regex

* Aside from `%[`
* Is most easily parsed as a regex

# plan9 filesystems

* plan9 was a research OS made by the classic unix people
* Changed *everything*
* New approch to filesystems
* More than one root
* bind and mount are sum and product types
* bind is literally called a union mount
