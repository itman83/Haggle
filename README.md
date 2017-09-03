# Haggle

Buy and sell items via live auction. 

This app is not fully complete yet, and there are a couple obvious problems associated with this codebase that I'll briefly touch on. 

For one, error emissions encapsulated by the networking layer have been commented out as I further investigate how they short curcuit subsequent observable sequences. One solution to gain more control over error's is to denote the Ouputs of a given view model as `Driver`s to be certain that they never error out, and that UI updates occur on the main thread. My current solution takes advantage of the `materialize` and `observeOn(scheduler:)` rx operators.

Secondly, its worth mentioning that some parts of the code violate separation of concerns principle. Some view models are passed in an `Item` model object as a dependency, which lives in the View Controller and is assigned a value upon cell tap events. One solution is to create a higher level coordinator object to subscribe to events to handle navigation all together.


![myItems](https://user-images.githubusercontent.com/19160637/29998230-ae088660-8fda-11e7-9ea2-b3e0c574279c.png)
![detail](https://user-images.githubusercontent.com/19160637/29998276-b3463c52-8fdb-11e7-94a5-29e62e5d5c2d.png)
![auction](https://user-images.githubusercontent.com/19160637/29998245-03e8880a-8fdb-11e7-8e81-c3c55266c37c.png)
![chatroom](https://user-images.githubusercontent.com/19160637/29998209-173d4c02-8fda-11e7-946f-a33473a2dd92.png)
![addItem](https://user-images.githubusercontent.com/19160637/29998257-65e2370e-8fdb-11e7-91a0-c876f76a92b3.png)


