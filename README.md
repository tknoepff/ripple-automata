# Ripple Automata

![Img](https://github.com/synhaptic/ripple-automata/blob/master/images/pattern.png)
<br>
<br>

**_Description_**
<br>

Cellular automata are intricate graphical structures that come from mathematical rules. They have a rich history in the fields of computation since they demonstrate how complex phenomena can emerge from simple lines of code. This [Processing](https://processing.org/) program is embedded in that tradition and adds some variations to an already existing model of emergent code, Conway’s Game of Life.

The rules are simple. A pixel, or cell, stays on when it has 2-3 other cells around it and turns off when there are less than 2 or more than 3 cells around it. The variants added to these rules were made to allow for the automata to stay active for extended periods of time and to be transformed into a visual installation. The age of each cell is tracked and represented by the intensity of its brightness. Once a cell lives for 100 iteration cycles, it dies and divides into five surrounding cells.


## Code Snippets

**_The rules for Conway’s Game of Life in code form_**

```javascript
if (current[x][y] == false && (neighbors(x,y) == 3)) {
  next[x][y] = true;

} else if (current[x][y] == true && (neighbors(x,y) < 2 || neighbors(x,y) > 3 )) {
  next[x][y] = false;

} else {
  next[x][y] = current[x][y];
}
```


## Demo

![Img](https://github.com/synhaptic/ripple-automata/blob/master/images/normal-growth.png)
![Img](https://github.com/synhaptic/ripple-automata/blob/master/images/ameoba-growth.png)


## Credits

**Creator** • Thomas Knoepffler <br>
**Advisor** • Alex Nathanson <br>
**Program** • Integrated Digital Media, NYU <br>
**Semester** • Fall 2019