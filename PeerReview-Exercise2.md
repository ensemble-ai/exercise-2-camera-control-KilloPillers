# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* Ezren Aldas
* *email:* jfaldas@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Camera is centered at vessel, a 5-unit cross is drawn when `draw_camera_logic` is true. The one minor flaw applies to all other stages, which is that `draw_camera_logic` is not true by default when switching into a camera.

___
### Stage 2 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Camera moves constantly along the z-x axis and vessel is correctly self-contained within the frame border box. Correct fields are exported, and they have correct behavior when edited from inspector. The box is correctly drawn when `draw_camera_logic` is true. 

Other than the minor flaw mentioned in stage 1, I noticed a potential issue that isn't necessarily mentioned in the stage objectives, so I'm not sure how much that should affect grading if at all. When switching into this camera, it does not teleport to the vessel's current position. Instead, it keeps whatever its position was already set at (e.g. the vessel's spawn point by default, if camera hasn't been used yet), and the vessel teleports into the camera's frame border box based on the border checks.

Additionally, when idle, the vessel maintains its global position instead of staying in the same position relative to the camera, but I think that's also just a good design principle and not a specified stage objective.

___
### Stage 3 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Camera is position-locked to target, follows the target at the specified exported`follow_speed` speed, and catches up to target at the specified exported `catchup_speed`. The `draw_logic` function correctly draws a 5-unit cross. The camera and vessel are correctly restricted from being more than `leash_distance` away from each other.

One minor issue is that the camera's y-position seems to be edited when the camera's global position is moved toward the target's global position. In effect, this means the camera moves closer to the vessel vertically rather than maintaining the `dist_above_target` specified in the inherited`camera_controller_base`, and the default `leash_distance` extends off-camera.

___
### Stage 4 ###

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Camera seems to jump immediately to `leash_distance` in front of vessel when vessel moves. It does successfully lead the vessel, if difficult to observe, and successfully moves back to vessel's position at `catchup_speed` after specified `catchup_delay_duration`. Draw function correctly draws reference on input. 

A major issue is that, like stage 2, the camera maintains whatever position it was previous set to rather than teleporting to vessel upon being active. In effect, this means when switching into this camera after traveling far from its previously set position, the camera travels at catchup speed all the way to the vessel's location.

Another minor issue is, like stage 3, the camera's y-position seems to be edited, so the camera is positioned closer vertically to the vessel than `dist_above_target`. In effect, the default `leash_distance` extends off camera, and thus the vessel is not visible when moving due to the aforementioned jumping behavior.

___
### Stage 5 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Camera exhibits correct behavior, but its y-position seems to be closer to vessel than `dist_above_target` and the default values for the pushbox's outer borders extend off-camera. This makes it difficult to observe the camera's behaviors. 

Otherwise, the camera does speed up when vessel is within the speedup zone, stay still when vessel is within center box, and is pushed at vessel's speed when vessel is at the pushbox borders. The draw function `draw_camera_logic` draws both the speedup zone's borders and the pushbox's borders, but with the default values for each box's size, only the speedup zone's borders appear on camera, which can be confusing.
___
# Code Style #
#### Style Guide Infractions ####
* [Unused `delta` variable isn't privated](https://github.com/ensemble-ai/exercise-2-camera-control-KilloPillers/blob/85bb9b6afdfedaf1b7e476bd5c66a64a56d2d7c8/Obscura/scripts/camera_controllers/four_way_push_box.gd#L26) - Stage 5 uses `_physics_process` without using its `delta` parameter variable. Godot's debugger (and [GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#functions-and-variables)) suggests using `_delta` instead when defining the function, since it's not used.

#### Style Guide Exemplars ####
* Variables are appropriately statically typed fairly consistently.
* Consistent spacing conventions used throughout scripts. The only inconsistencies I've found are [a probably accidental missing space](https://github.com/ensemble-ai/exercise-2-camera-control-KilloPillers/blob/85bb9b6afdfedaf1b7e476bd5c66a64a56d2d7c8/Obscura/scripts/camera_controllers/auto_scroll.gd#L34) and statically typed variables either typed with no spaces (e.g. [`var lead_speed:float`](https://github.com/ensemble-ai/exercise-2-camera-control-KilloPillers/blob/85bb9b6afdfedaf1b7e476bd5c66a64a56d2d7c8/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L4)) or with one space as per the [GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#declared-types) (e.g. [`var timer: float`](https://github.com/ensemble-ai/exercise-2-camera-control-KilloPillers/blob/85bb9b6afdfedaf1b7e476bd5c66a64a56d2d7c8/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L10)). Although to be fair, I think the variables with no spaces are mostly from the professor or based on his work.
___

# Best Practices #
#### Best Practices Infractions ####
I noticed there seems to be only a few commits, one of which adds all progress from stages 1-4. I wonder if it would have been better practice to have more commits, potentially such as one for each stage.

#### Best Practices Exemplars ####
The commit messages are descriptive. 

I also like when descriptive comments are used to explain/label sections, such as in [`auto_scroll.gd`](https://github.com/ensemble-ai/exercise-2-camera-control-KilloPillers/blob/85bb9b6afdfedaf1b7e476bd5c66a64a56d2d7c8/Obscura/scripts/camera_controllers/auto_scroll.gd#L29) and within most cameras' [`draw_logic`](https://github.com/ensemble-ai/exercise-2-camera-control-KilloPillers/blob/85bb9b6afdfedaf1b7e476bd5c66a64a56d2d7c8/Obscura/scripts/camera_controllers/auto_scroll.gd#L62).
