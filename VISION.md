# IndieK's values
- Develop an intelligent digital assistant with which the user can communicate in natural language, and via freehand drawing and writing. One source of inspiration is the fictional [JARVIS](https://www.youtube.com/watch?v=Wx7RCJvoCMc) program from the _Iron Man_ movies; another one is [this software](https://youtu.be/PJqbivkm0Ms), used in the _Minority Report_ movie. 
- Promote learning via the use of metacognition  
- Promote debating via the use of metacognition  
- Promote scientific skepticism  
- Promote philosophical skepticism  
- Promote creation of objective knowledge  
- Promote creation of public knowledge  
- Foster questioning and curiosity  
- Use machines as cognitive prosthetics to enhance our capacities, e.g. memory and metacognition (organization of one's own thoughts)  
- Seamless integration between machines and human cognition  
- Provide easy access to formal mathematical knowledge to the layman

# Integrating digital technologies to our daily thinking activity
Dreaming is a beautiful faculty of human beings. It is closely related to emotions, creativity and imagination.
Technology can allow us to dream more, by offering us a virtual platform in which we may interact with our own thoughts.
The days of mouse and keyboard interaction with computers are behind us. Even cumbersome touch-screen menus on a cell phone are too limited in my opinion.
It is time to adapt virtual items to human cognition, and not the other way around.
I claim that we have the tools for it.

# Virtual worlds in IndieK
One feature that I want to implement into IndieK is the ability to open as many "virtual worlds" as needed.
Microsoft Windows is based on this well-known user interface principle: the window!

Thus, I call a "world" an interactive virtual space.
In the simplest form, it is 2-dimensional. Think of infinite planes that can be moved in 3-space manually. The apparent size can be shrinked or stretched at will, as space allows.

At the creation time of a new world, a "type" must be selected by the user.
The default type is "workspace", 
which allows the most freedom. 
An option for this type is "shared mode", 
which allows multi-user database usage.

Other types are "Database", which can be activated in read-only or read-and-write mode,
and "publishing". 

Worlds can be named and saved.

## Database type
The database type allows exploration and browsing of stored information.
Any item from there can be dragged and dropped into a workspace world.
And similarly, a publishing world accepts any item from any other type of world.

If write mode is activated, contents, links and other attributes may be edited on the fly.

## Workspace type
Two workspaces can always be merged, and a single workspace may be subdivided into two or more workspaces.

The workspace type allows full interactivity and easy capture of media.
For instance, if there is a webcam filming the user, and if computer vision has been appropriately developed into the application, the user may just dance in front of the camera, and see her reflection in the workspace. Image and video may be edited on the fly. One might, for instance, perform image segmentation on the video and only extract her dancing silhouette, without any background image.
There is great potential for artistic creation in this example.

The workspace also allows capture of handwriting, 
and performs Optimal Character Recognition to transform, if requested, 
the handwriting into a typed text item.

The workspace allows the drawing of boundaries, and labeling of each region, 
with possible color coding. Each such region can become a "topic". 
But these may alternatively be represented as bubbles, 
to avoid item visual duplication in the event of an item lying in the 
intersection of two topics.

Alternatively, color coding of a few topics can become apparent on demand.

Freehand drawing can be used for two things. First, it can be used to draw something. 
In this case, the drawing itself can be saved as an item into the database. 
The second use is to introduce relationships between items.
It can be a directed or undirected link (the user draws a line or an arrow, 
or even says the following sentence at loud: "draw arrow from A to B") or it can be a 
boundary circling items that should be grouped into the same topic 
(this is the bubble representation mentioned above). 
Thus, circling items triggers the question of assigning the inside 
(or outside) items to an existing or new topic.

Similarly, drawing a line triggers the question of creating an undirected link between 
two topics, or between two items. And an arrow triggers the same question 
for a directed link.

Links can be labeled and grouped. Their appearance can be changed, 
and they can be made visible or hidden.
Thus, links are a specific kind of "items".

## Technical infrastructure
Because of all the above, Graph and NoSQL databases are better suited to this purpose.

Also, full potential of the user interface requires Augmented or Virtual Reality.

Few commands are needed. We can think of easily accessible physical buttons, 
for the most common ones: "new item", "save to DB", "show saved items".
