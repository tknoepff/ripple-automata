# From The Underground

![Gif](https://github.com/tknoepff/from-the-underground/blob/master/gifs/gif-1.gif)
<br>
<br>

**_Description_**
<br>

From the Underground is a first-person infinite running game made in Unity, a three-dimensional game development environment. Players are vacillating from two emotional states while playing the game, flow and fear. The flow comes from mastering obstacles in cyberspace through running and jumping mechanics. The fear comes from the game's unseen enemy that's chasing the player, as contact with it will be game over. The game has a digital and cyberpunk aesthetic.

The mechanics rely on intuitive running and jumping controls combined with the nuances of the Unity physics engine like gravity and momentum. The graphics use post processing features built into the Unity engine such as bloom lighting and glow effects. When the enemy approaches, graphical distortions begin to obscure the screen as color channels become skewed and glitch.


## Software Used
- [Unity LTS 2018.4](https://unity.com/)


## Assembly

![Img](https://github.com/tknoepff/from-the-underground/blob/master/images/cap-1.png)
![Img](https://github.com/tknoepff/from-the-underground/blob/master/images/cap-2.png)
![Img](https://github.com/tknoepff/from-the-underground/blob/master/images/cap-3.png)



## Code Snippets

**_Code for the player behavior class, made using the Unity Vector() function_**

```c
void Start() {
  rb = GetComponent Rigidbody();
  enemy = GameObject.Find("Enemy");
  cam = GameObject.Find("Main Camera");
  end_play = GameObject.Find("Near End");
  curr_speed = 100;
  gravity = -1000;
  Jump_force = 4500;
}


void FixedUpdate() {
  float horizontal = Input.GetAxis("Horizontal");
  float vertical = Input.GetAxis("Vertical");
  Vector3 ground_motion_vector = new Vector3(horizontal, 0, vertical);
  transform.Translate(ground_motion_vector, Space.Self);

  if (Input.GetAxis("Jump") > 0 && is_grounded) {
    jump_vector = new Vector3(0, jump_force, 0);
    rb.AddForce(jump_vector);
  }

  if (rb.velocity.y < 5 && !is_grounded) {
    rb.AddForce(new Vector3(0, gravity, 0));
  }
}

```


## Demo

Click [here](https://github.com/tknoepff/from-the-underground/tree/master/videos) for video demos

![Img](https://github.com/tknoepff/from-the-underground/blob/master/images/gameplay-6.png)
![Img](https://github.com/tknoepff/from-the-underground/blob/master/images/gameplay-1.png)
![Img](https://github.com/tknoepff/from-the-underground/blob/master/images/gameplay-4.png)




## Credits
**Creator** • Thomas Knoepffler <br>
**Advisor** • Alexandros Lotsos <br>
**Program** • Integrated Digital Media, NYU <br>
**Semester** • Summer 2019