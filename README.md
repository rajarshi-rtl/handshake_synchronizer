# Handshake Synchronizer with Protected Source Data Capture

## Overview

This mini-project implements a **Handshake Synchronizer** in Verilog for reliable **Clock Domain Crossing (CDC)** between asynchronous clock domains.

Unlike a conventional handshake synchronizer, this implementation introduces an **additional source-side Capture Flip-Flop**, which preserves the data to be transferred even if the source input changes while the synchronizer is busy.

---

## Motivation

A standard handshake synchronizer assumes that the source data remains stable until the transfer completes.

In many practical systems, however, the source logic may continue updating its data while the synchronizer is still servicing a previous transaction. This can overwrite the value stored in the source register, leading to incorrect data being transferred.

To address this limitation, this design adds a **Capture Flip-Flop** before the source register.

## Architecture

The design consists of:

* Source-side Capture Flip-Flop (Additional enhancement)
* Source Register
* Sender FSM
* Request Synchronizer (2-FF)
* Receiver FSM
* Destination Register
* Acknowledge Synchronizer (2-FF)

---

## Improvement

### Conventional Handshake Synchronizer

```
Input Data ──► Source Register
```

If the source updates the input while `BUSY = 1`, the source register may be overwritten before the handshake completes.

---

### Proposed Architecture

```
Input Data ──► Capture FF ──► Source Register
```

The Capture Flip-Flop acts as a temporary holding register.

It captures the input **only once** when a new transfer begins (`SEND = 1` and `BUSY = 0`). During the handshake, even if the external source changes its data, the captured value remains protected until the transfer completes.

---

## Verification

The design was verified using Verilog testbenches with multiple asynchronous clock frequencies.

The simulations confirm:

* Correct REQUEST/ACKNOWLEDGE sequencing
* Reliable CDC operation
* Stable data transfer
* Protection against source data changes while `BUSY` is asserted

---

## Advantages

* Reliable data transfer between asynchronous clock domains using handshake protocol.
* Preserves the requested data even if the external input changes while the synchronizer is busy.
* Prevents the current transaction from being overwritten by subsequent input updates.


## Disadvantages

* Increased Latency
* Additional Hardware and Power Consumption

## Author
Rajarshi Ray  
B.Tech in Electronics and Telecommunication Engineering  
IIEST Shibpur
