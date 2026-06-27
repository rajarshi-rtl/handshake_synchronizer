# Handshake Synchronizer with Source Data Capture

## Overview

This project implements a **4-phase Handshake Synchronizer** in Verilog for reliable **Clock Domain Crossing (CDC)** between asynchronous clock domains.

Unlike a conventional handshake synchronizer, this implementation introduces an **additional source-side Capture Flip-Flop**, which preserves the data to be transferred even if the source input changes while the synchronizer is busy.

---

## Motivation

A standard handshake synchronizer assumes that the source data remains stable until the transfer completes.

In many practical systems, however, the source logic may continue updating its data while the synchronizer is still servicing a previous transaction. This can overwrite the value stored in the source register, leading to incorrect data being transferred.

To address this limitation, this design adds a **Capture Flip-Flop** before the source register.

The capture flip-flop samples the input **only when**

* `SEND = 1`
* `BUSY = 0`

Once captured, the value remains unchanged throughout the entire handshake transaction, irrespective of subsequent changes on the input bus.

This architectural enhancement guarantees that the receiver always obtains the exact data that initiated the transfer.

---

## Architecture

The design consists of:

* Source-side Capture Flip-Flop (engineered enhancement)
* Source Register
* Sender FSM
* Request Synchronizer (2-FF)
* Receiver FSM
* Destination Register
* Acknowledge Synchronizer (2-FF)

```
Source Domain
─────────────

Input Data
    │
    ▼
Capture FF   ← Samples only when SEND & !BUSY
    │
    ▼
Source Register
    │
    ├────────────── Data Bus ─────────────► Destination Register
    │
Sender FSM
    │
REQUEST
    ▼
2-FF Synchronizer
    ▼
Receiver FSM
    │
ACK
    ▼
2-FF Synchronizer
    ▼
Sender FSM
```

---

## Engineered Improvement

### Conventional Handshake Synchronizer

```
Input Data ──► Source Register
```

If the source updates the input while `BUSY = 1`, the source register may be overwritten before the handshake completes.

---

### Proposed Architecture

```
Input Data
    │
    ▼
Capture FF
    │
    ▼
Source Register
```

The Capture Flip-Flop acts as a temporary holding register.

It captures the input **only once** when a new transfer begins (`SEND = 1` and `BUSY = 0`). During the handshake, even if the external source changes its data, the captured value remains protected until the transfer completes.

This improves the robustness of the synchronizer without altering the standard REQUEST–ACKNOWLEDGE protocol.

---

## Features

* 4-phase REQUEST–ACKNOWLEDGE handshake
* Asynchronous clock domain crossing
* Moore FSM implementation
* Dual flip-flop synchronizers for metastability mitigation
* Source-side capture mechanism for improved data integrity
* Parameterizable data width
* Verilog RTL implementation
* Functional verification through simulation

---

## Verification

The design was verified using Verilog testbenches with multiple asynchronous clock frequencies.

The simulations confirm:

* Correct REQUEST/ACKNOWLEDGE sequencing
* Reliable CDC operation
* Stable data transfer
* Protection against source data changes while `BUSY` is asserted

---

## Key Learning Outcomes

* Clock Domain Crossing (CDC)
* Handshake Synchronizers
* Metastability Mitigation
* Moore FSM Design
* Verilog RTL Design
* Digital System Architecture
* Design Enhancement through Architectural Modification
