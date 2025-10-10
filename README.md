# UART-ALU para FPGA (Proyecto en VHDL)

Este proyecto implementa una **Unidad Aritmético Lógica (ALU)** de 4 bits controlada mediante comunicación **UART**, utilizando una FPGA (Arty Z7-10).  
El diseño permite recibir tres bytes desde un puerto UART (A, B y operación) y mostrar el resultado de la operación en los **LEDs** de la placa.

---

## 🧩 Descripción general

El sistema se compone de los siguientes módulos principales:

- **ALU (ALU.vhd)**  
  Implementa operaciones aritméticas y lógicas básicas entre dos operandos de 4 bits.  
  Operaciones disponibles:
  | Código (Op) | Operación |
  |--------------|-----------|
  | `000` | Suma |
  | `001` | Resta |
  | `010` | AND |
  | `011` | OR |
  | `100` | XOR |
  | `101` | NOT |
  | `110` | Shift Left |
  | `111` | Shift Right |

- **UART Receiver (uart_rx.vhd)**  
  Recibe datos en formato serial según el baud rate especificado (por defecto `115200 bps`).  
  Entrega los bytes recibidos al módulo superior mediante la señal `rx_data` y genera un pulso `rx_data_rdy` al finalizar la recepción de cada byte.

- **UART Baud Generator (uart_baud_gen.vhd)**  
  Genera el pulso de habilitación de muestreo (`baud_x16_en`) a 16 veces la frecuencia del baud rate.

- **Top Level (uart_alu_top.vhd)**  
  Coordina la recepción de tres bytes (A, B y Op), activa la ALU una vez recibidos, y muestra el resultado en los LEDs.

- **Testbench (uart_alu_top_tb.vhd)**  
  Simula la recepción de datos UART para verificar el funcionamiento del sistema completo.

---

## ⚙️ Flujo de operación

1. El sistema espera bytes provenientes del puerto UART.  
2. Al recibir:
   - Primer byte → se almacena como **A**.  
   - Segundo byte → se almacena como **B**.  
   - Tercer byte → se interpreta como **Op** y se ejecuta la operación en la ALU.  
3. El resultado de la operación se muestra en los **LEDs** del sistema.

---

## 🧪 Simulación

El proyecto incluye un **testbench** (`uart_alu_top_tb.vhd`) que envía diferentes secuencias UART simulando las siguientes operaciones:

- `A=3, B=5, Op=000` → Resultado: 8  
- `A=7, B=2, Op=001` → Resultado: 5  
- `A=9, B=3, Op=010` → Resultado: 1  

### Cómo ejecutar la simulación en Vivado

1. Abre el proyecto en Vivado.  
2. Agrega `uart_alu_top_tb.vhd` como archivo de simulación.  
3. Ejecuta *Run Simulation → Run Behavioral Simulation*.  
4. Observa en el waveform las señales `rxd`, `rx_data`, `rx_ready`, `A`, `B`, `Op`, y `leds`.

---


## 🧠 Autor

**Laura Moreno**   
Octubre 2025

