# Sprite Slicing

Godot asset to slice 2D sprites.

- `Slicer2D` is the main node and contains all the functionality to slice sprites.
- `Sliceable2D` is the type of the object sliced by `Slicer2D`.

This document uses the format of the official Godot docs.

That is `type name` for variables and `return_type name(type name)` for functions.

## The SlicingData datatype

`SlicingData` is the type which contains information of a sliced object.
It contains the following fields:

```cpp
class SlicingData:
	Sliceable2D object
	Vector2 global_enter
	Vector2 global_out
	int cut_number
	Array slices
```

- `object`: the original sliced object, this reference might be invalidated by `queue_free()` if you configure the Slicer2D to destroy that object after the slices are created.

- `global_enter`: global coordinate of the entry of the cut in the object.

- `global_out`: global coordinate of the exit of the cut in the object.

- `cut_number`: number of the actual cut.

- `slices`: array of references to the slices generated by the processed slice.

Tip: you can use `global_enter` and `global_out` to create animations.

## Slicer2D
### Method list
```python
Array slice_world(Vector2 start, Vector2 end, int collision_layer = 0x7FFFFFFF, bool destroy = true)
```
Tries to find `Sliceable2D`s to cut from start to end. Returns an Array of SlicingData one for each sliced object.

- `start`: the start of the cut in global coordinates.

- `end`: the end of the cut in global coordinates.

- `collision_layer`: optional parameter to restrict the cut using a collision layer.

- `destroy`: if true the object will be destroyed with queue_free() so only its slices are active.

```python
SlicingData slice_one(Sliceable2D item, Vector2 start, Vector2 end, int collision_layer = 0x7FFFFFFF, bool destroy = true)
```
Does the same as `slice_world` but only cuts `item` if it is found in the cut.


### Properties

```python
Physics2DDirectSpaceState space_state
```
For advanced users. Assign a custom space state and it will be used to detect sliceable objects. That way you can isolate the interaction of a `Slicer2D` as the sliceable objects are identified using raycasts. Default value: `null`

```python
float min_area.
```
Minimum approximate area. Default value: `0.01`

```python
float impulse_intensity
```
This value is multiplied to the force applied to the slices when you cut them. Default value: `100.0`


## Project Demo

The `demo` folder contains a basic demo showing the functionality of this asset.
Open `demo/TestScene.tscn` and test the asset in action!

### Assets
- [apple.png](https://opengameart.org/content/fruit-graphics-from-caveexpress): CC-BY-SA 3.0


# Asset usage

- Copy `Sliceable2D.gd` and `Slicer2D.gd` to your game.
- Add a `Slicer2D` node to your scene.

### Sliceable2D

In order to create a sliceable object:
1. Create a new scene with a `RigidBody2D` as the root node.
2. Add a script to the `RigidBody2D` and put at the beginning of the script `extends Sliceable2D`
3. Add a Sprite node and add a texture.
4. Click on the `RigidBody2D` and check the inspector. In Script Variables you should see a field "Sprite Node". Click on it and select your `Sprite`.
5. Add a `CollisionPolygon2D` or a `CollisionShape2D` to your `RigidBody2D`.

Notes:
- The order of the required children doesn't matter, they just need to exist. The only special requirement is defining the "Sprite Node" field in the inspector.
- Collisions must fit the figure of the sprite because the slices are generated using the
collision shapes.
- The `Sprite` can have `flip_h` and `flip_v` enabled.
- You can add as many collision shapes as you wish. I you use `CollisionShape2D` the supported `Shape2D` is: `ConvexPolygonShape2D`. In the future it will support `CapsuleShape2D`, `CircleShape2D` and `RectangleShape2D` too.
- After a cut, the created slices will replace the node pointed by "Sprite Node" with a `MeshInstance2D`.
- The `Sliceable2D` created by a cut will be reparented to the same parent of the original
sliced object.

Advanced usage:

If you want to change the texture of a `Sliceable2D` just access the property `texture` of the "Sprite Node". Before the first cut you will access the `Sprite` you defined, and if you are accessing a sliced `Sliceable2D` you will be accessing the `texture` property of a `MeshInstance2D`. The node name of the original `Sprite` will be respected by the new `MeshInstance2D` so it is secure to access with the `$` operator. Just keep in mind the new texture will be mapped based on the UV of the original texture.

You can define the following in your script to gain more control over the slicing process:
```python
int cut_limit_val
```
If the `cut_number` is >= than `cut_limit_val` this object wont be sliced anymore.
You can disable slicing on an object defining `cut_limit_val` with values of 0 or lower.

```python
void _on_sprite_sliced(SlicingData data)
```
This function will be called on the sliced object (not the slices generated by the cut) and data will contain the information about the slicing of your object.


## Donations
If you want you can donate some bucks with the following options: 
- [Paypal](https://www.paypal.me/lupoDharkael)