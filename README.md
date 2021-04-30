## How to Use:

1. Compile (make sure filles.txt is in the directory)
      iverilog -o my_design.vvp -c filles.txt

2. Run
     vvp my_design.vvp

3. Open with gtkwave tool
      gtkwave cpu_wavedata.vcd

## Timing Diagrams

### Instruction Read Miss
![TD Instruction Read Miss](https://user-images.githubusercontent.com/59219626/116731350-32e08500-aa07-11eb-8113-536909110dcd.png)

### Instruction Read Hit
![TD Instruction Read Hit](https://user-images.githubusercontent.com/59219626/116731399-44c22800-aa07-11eb-8ed0-0292ca304c12.png)

### After Reset
![TD After Reset](https://user-images.githubusercontent.com/59219626/116731451-55729e00-aa07-11eb-9597-0299cb56798f.png)

### Zoom out view
![TD zoom out view](https://user-images.githubusercontent.com/59219626/116731517-691e0480-aa07-11eb-8cae-3f625bf424c9.png)
