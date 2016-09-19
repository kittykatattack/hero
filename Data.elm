module Data exposing (..)
import Markdown

{-
###Data.elm

Contains the data that's used by the game to display the pages of the story.

- `inventory`: A list of `Item`s, in this case the "Magic Pills" and the 
  "Transformations".
- `infoPages`: A list of three markdown elements that describe the the main 
   information pages in the game (`infoPageOne`, `infoPageTwo` and `infoPageThree`).
- `storyPhases`: A list of each of the 9 major phases of the story. These are 
   displayed above the story progress meter
- `storyPhaseChapters`: A list of the 3 major sections of the story. These are displayed 
   above the story meter.
- `story`: a list of `Page` records. These define each page that's displayed in the 
   story. Each page has a unique `ID` that is used to link pages to buttons.
-}

-- INVENTORY

type alias Item = 
  { name : String
  , image : String
  , quantity : Int 
  }

type alias Inventory = List Item

inventory : Inventory
inventory =
  [
    { name = "Magic Pills"
    , image = "pill.png"
    , quantity = 0
    }
  ,
    { name = "Transformations"
    , image = "wand.png"
    , quantity = 0
    }
  ]


-- STORY METADATA

 -- A list of three markdown elements that describe the the main 
 -- information pages in the game (`infoPageOne`, `infoPageTwo`
 -- and `infoPageThree`).

infoPageOne =
  """
  ## Phase I: The Departure

  A. **Call to adventure** – the hero learns what he/she must do.

  B. **Supernatural aid** – something magical happens that gives the hero supernatural powers and/or weapons
  
  C. **The Journey begins** – the hero faces his or her fears and takes the first steps into the unknown.    
  """ 

infoPageTwo =
  """
  ## Phase II: The Journey 

  A. **Tests and ordeals** – the hero has to face many challenges and ordeals along the way. In doing so, the hero tests the strength of their character.
  
  B. **Confronting their goal** – eventually the hero faces the thing they have been looking for. They must either defeat it or make peace with it
  
  C. **Transformation** – the character of the hero is forever changed by their experiences along the journey. It could be by falling in love or by realizing something about the true nature of themselves or the world.
  
  D. **Fulfilling the quest** – the goal of the quest has been achieved.  The hero feels purified and renewed.
  """

infoPageThree =
  """
  ## Phase III: The Return 

  A. **The "Magic Flight"** – the journey back home often involves some magic or special event to break the spell of the quest.
  
  B. **Returning home** - to face family and friends again, but now as a changed person, perhaps also to seek revenge or to fulfill a prophecy.
  
  C. **Adjusting to a normal life** - finding a way to return to living as a normal person again after the adventures of the heroic journey.
  """

infoPages =
  [ infoPageOne
  , infoPageTwo
  , infoPageThree
  ]


-- The major phases of the story, representing increasing depth layers
storyPhases = 
  [ "Call to Adventure"
  , "Supernatural Aid"
  , "The Journey Begins"
  , "Tests and Ordeals"
  , "Confronting the Goal"
  , "Transformation"
  , "Fulfilling the Quest"
  , "Returning Home"
  , "Adjusting"
  ]


-- The `storyPhaseChapters` are displayed in the InfoBox
-- underneath the story phase meter

chapter1 = "Phase 1: The Departure"
chapter2 = "Phase 2: The Journey"
chapter3 = "Phase 3: The Return"

storyPhaseChapters = 
  [ chapter1
  , chapter2
  , chapter3
  ]


-- INFO WINDOW CONTENT




-- PAGES

{-
Page IDs are a decimal number. The number to the left of the decimal
represents which story level the page is at (1 to 10, in this 
game). The number to the right
of the decimal represents which section of that level the page reprents.
For example, 1.1 represents the first section of story level 1.
3.2 represents the second section of story level 3. 
-}
type alias ID = Float

type alias Page =
  { id : ID -- Used to identify and link pages together
  , heading : String -- The main page heading
  , subheading : String -- The optional subheadin
  , storyChapter : String -- The chapter that this page belongs to
  , storyPhaseChapter : Int -- The story phase that the page belongs to (1,2 or 3)
  , description : String -- Markdown text that describes the Msg
  , pillsLeft : Int -- The number of Magic Pills the player has at this page
  , transformations : Int -- The number of transformations the player had made at this page.
  , image : String -- The page illustration
  , alignment : String -- How the content box is aligned
  , choices : List String -- The text label's for the choices the player has
  , choiceLinks : List ID -- The page ID's used to link each page
  , buttonLabel : String -- The label for the button
  , buttonEventDescription : String -- Text that describes what the button does
  , buttonEventType : String -- "next", "Msg", "question", "gameover",
  , buttonLink : ID -- The ID of the page that the button should link to
  }

type alias Story = List Page

-- The data for all the story pages

story : Story
story = 
  [
    { id = 1.1
    , heading = "Introduction"
    , subheading = ""
    , storyChapter = chapter1
    , storyPhaseChapter = 1
    , description = 
      """
  You are 19 years old and bored with life in your small medieval town. 
  Your parents run a general store and your job is to make deliveries to 
  their wealthy customers. One day your parents send you out on a long 
  delivery that will take several days journey to complete. They suggest 
  you invite some friends along for protection and to make the journey 
  more fun. You choose your three best friends to take the trip with you. 
  """
    , pillsLeft = 0
    , transformations = 0
    , image = "illustration_1-1.png"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ ]

    -- Button
    , buttonLabel = "Start"

    -- The button event description appears above the button
    , buttonEventDescription = "Start your journey"

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 1.2
    }
  ,
    { id = 1.2
    , heading = "Call to Adventure"
    , subheading = ""
    , storyChapter = chapter1
    , storyPhaseChapter = 1
    , description = 
      """
  Along the way your party is attacked by bandits on horseback. 
  They kill one of your friends and club you on the head. 
  They leave you for dead and kidnap your other two friends to hold them for ransom.
      """
    , pillsLeft = 0
    , transformations = 0
    , image = "illustration_1-2.png"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ ]

    -- Button
    , buttonLabel = "Next"

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 1.3
    }
  ,  
    { id = 1.3
    , heading = "Call to Adventure"
    , subheading = ""
    , storyChapter = chapter1
    , storyPhaseChapter = 1
    , description = 
      """
  As you wake up alone and injured in the dark forest you hear something 
  approaching. You can either try to hide from it or confront it. What do you do?
      """
    , pillsLeft = 0
    , transformations = 0
    , image = "illustration_1-3.png"
    , alignment = "left"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "Try to hide from it" 
        , "Confront it"
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 1.4 -- Game Over
        , 2.1 -- Supernatural Aid and Quest begins
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,  
    { id = 1.4
    , heading = "Call to Adventure"
    , subheading = ""
    , storyChapter = chapter1
    , storyPhaseChapter = 1
    , description = 
      """
  **You die alone in a dirt hole under a tree.**
      """
    , pillsLeft = 0
    , transformations = 0
    , image = "illustration_1-4.png"
    , alignment = "left"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ 
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 
        ]

    -- Button
    , buttonLabel = "Go Back"

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "gameover"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 1.3
    }
  ,
    { id = 2.1
    , heading = "Supernatural Aid and Quest Begins"
    , subheading = "The Story (page 1 of 5)"
    , storyChapter = chapter1
    , storyPhaseChapter = 1
    , description = 
      """
  You are greeted by a shimmering spirit who heals your injuries and tells 
  you that your friends are being held in the Warlord’s castle. She also tells 
  you a mysterious story about a deadly threat to your entire village along with 
  a prophecy explaining how it can be saved.  
      """
    , pillsLeft = 0
    , transformations = 0
    , image = "illustration_2-1.png"
    , alignment = "left"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ ]

    -- Button
    , buttonLabel = "Next"

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 2.2
    }
  ,
    { id = 2.2
    , heading = "Supernatural Aid and Quest Begins"
    , subheading = "The Story (page 2 of 5)"
    , storyChapter = chapter1
    , storyPhaseChapter = 1
    , description = 
      """
 Before you were born, your village went through very hard times. People were starving and 
 all seemed lost. In desperation, they agreed to a secret deal with the evil Warlord. He 
 promised them prosperity for 20 years but in return they would owe him a fortune. If the 
 debt were not paid in full by the 20th anniversary, the evil Warlord and his bandits would 
 destroy the village and kill or enslave all the young people. The only way to prevent 
 losing their children was to pay him off or destroy him.
      """
    , pillsLeft = 0
    , transformations = 0
    , image = "illustration_2-2.png"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ ]

    -- Button
    , buttonLabel = "Next"

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 2.3
    }
  ,  
    { id = 2.3
    , heading = "Supernatural Aid and Quest Begins"
    , subheading = "The Story (page 3 of 5)"
    , storyChapter = chapter1
    , storyPhaseChapter = 1
    , description = 
      """
  The villagers thought that they could raise the money in the years of 
  prosperity promised by the Warlord. Their riches should be more than 
  enough to pay him back. But several unexpected disease epidemics set them 
  back. After 20 years, they did not have enough to pay the Warlord his ransom. 
  Time was up and in a few days the Warlord wanted his payment. Knowing this, 
  your parents sent you away on an errand far outside the village in the hopes 
  you could escape the fate of capture and enslavement.
      """
    , pillsLeft = 0
    , transformations = 0
    , image = "illustration_2-3.png"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ ]

    -- Button
    , buttonLabel = "Next"

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 2.4
    }
  ,  
    { id = 2.4
    , heading = "Supernatural Aid and Quest Begins"
    , subheading = "The Story (page 4 of 5)"
    , storyChapter = chapter1
    , storyPhaseChapter = 1
    , description = 
      """
  The Gods prophesized that the Warlord could be only be destroyed by his most 
  trusted generals acting together to kill him. But he was constantly surrounded 
  by his most loyal generals. None seemed willing to betray him. It was unlikely 
  this prophecy could ever come true.
      """
    , pillsLeft = 0
    , transformations = 0
    , image = "illustration_2-4.png"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ ]

    -- Button
    , buttonLabel = "Next"

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 3.1
    }
  ,  
    { id = 3.1
    , heading = "Supernatural Aid and Quest Begins"
    , subheading = "The Story (page 5 of 5)"
    , storyChapter = chapter1
    , storyPhaseChapter = 1
    , description = 
      """
  The spirit also gives you 5 magic pills. Each pill temporarily turns you into 
  someone or something else for about 15 minutes. When the pill wears off you 
  quickly revert back to being yourself. **But be warned! Anyone who takes a pill 
  more than twice will remain what they transformed into**. If you take a pill for 
  a third time, you can never go back to being who you were. You are forever 
  changed and must live out your life in your new form, whatever that may be - 
  a bird, a bandit, or a king. After hearing the spirit’s story, what do you decide to do?
      """
    , pillsLeft = 5
    , transformations = 0
    , image = "illustration_3-1.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "Run home to save your parents." 
        , "Accept the magic pills and begin journey."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 3.2
        , 4.1 
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,
    { id = 3.2
    , heading = "Supernatural Aid and Quest Begins"
    , subheading = ""
    , storyChapter = chapter1
    , storyPhaseChapter = 1
    , description = 
      """
  **You return home and are killed by the bandits** 
      """
    , pillsLeft = 5
    , transformations = 0
    , image = "illustration_3-2.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ 
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [  
        ]

    -- Button
    , buttonLabel = "Go Back"

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "gameover"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 3.1
    }
  ,  
    { id = 4.1
    , heading = "Trial #1"
    , subheading = ""
    , storyChapter = chapter2
    , storyPhaseChapter = 2
    , description = 
      """
  You are travelling alone through the forest on a mission to rescue your friends. 
  Along the way you meet a talking crow who says he knows a safe route to the Warlord’s 
  castle. He can fly ahead and lead you there quickly. But there is a price. 
  He wants one of your magic pills.
      """
    , pillsLeft = 5
    , transformations = 0
    , image = "illustration_4-1.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "You think the crow is trying to trick you so you tell him to leave you alone and you make your way on your own."
        , "You accept the crow’s offer and he starts to lead you."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 4.3
        , 4.2
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,  
    { id = 4.2
    , heading = "Trial #1"
    , subheading = ""
    , storyChapter = chapter2
    , storyPhaseChapter = 2
    , description = 
      """
  **The crow leads you into a trap and you are killed by bandits. The crow steals all of your pills.**
      """
    , pillsLeft = 0
    , transformations = 0
    , image = "illustration_4-2.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ 
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 
        ]

    -- Button
    , buttonLabel = "Go Back"

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "gameover"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 4.1
    }
  ,  
    { id = 4.3
    , heading = "Trial #2"
    , subheading = ""
    , storyChapter = chapter2
    , storyPhaseChapter = 2
    , description = 
      """
  In the evening, as it is getting dark, you are alone and stumbling along the forest trail. 
  You hear a camp of bandits and see their fires in the distance. You think you can hear 
  them talking about your friends but aren’t sure.      
      """
    , pillsLeft = 5
    , transformations = 0
    , image = "illustration_4-3.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "You crawl to the edge of their camp, hiding in the trees just beyond the light of their fires, to listen to them."
        , "You decide to skirt around the camp and avoid them."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 4.4
        , 4.5
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,  
    { id = 4.4
    , heading = "Trial #2"
    , subheading = ""
    , storyChapter = chapter2
    , storyPhaseChapter = 2
    , description = 
      """
  **You stumble upon a couple of guards out on patrol. They kill you.**
      """
    , pillsLeft = 5
    , transformations = 0
    , image = "illustration_4-4.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ 
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 
        ]

    -- Button
    , buttonLabel = "Go Back"

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "gameover"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 4.3
    }
  ,  
    -- 5
    { id = 4.5
    , heading = "Trial #3"
    , subheading = ""
    , storyChapter = chapter2
    , storyPhaseChapter = 2
    , description = 
      """
  You overhear where your friends are being held. It is in the tower of the heavily guarded castle. 
  The castle is about a 6 hour hike through the forest and then across some open fields.

  Unfortunately, the guards on the castle walls will be able to see you coming from any direction 
  as you cross the open fields towards them. When you reach the edge of the fields surrounding 
  the castle you must find a way to get past the guards. You decide to take one of your 5 magic 
  pills and temporarily become:      
      """
    , pillsLeft = 5
    , transformations = 0
    , image = "illustration_4-5.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "A small bird who can fly over the walls and into the castle tower undetected by the guards."
        , "One of the senior generals so you can walk past the guards and into the prison tower where your friends are held."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 5.1 -- 6a
        , 5.2 -- 6b
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
   , 
     -- 6a
    { id = 5.1
    , heading = "Confronting the goal"
    , subheading = "Rescuing your friends"
    , storyChapter = chapter2
    , storyPhaseChapter = 2
    , description = 
      """
  You land beside your friends but have to wait until your bird shape wears off. 
  When you reappear as yourself, you untie your two friends and discuss an escape 
  plan with them. You decide:      
      """
    , pillsLeft = 4
    , transformations = 1
    , image = "illustration_5-1.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "that all three of you will take a pill, become small birds, and fly out the window to the forest and safety."
        , "only you will take a pill and become a general and walk your “prisoners” past the guards."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 9.8 -- 7a
        , 6.1 -- 10h
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,
    -- 6b
    { id = 5.2
    , heading = "Confronting the goal"
    , subheading = "Rescuing your friends"
    , storyChapter = chapter2
    , storyPhaseChapter = 2
    , description = 
      """
  You untie your two surprised friends, explain who you are, and quickly hatch 
  an escape plan. You decide:       
      """
    , pillsLeft = 4
    , transformations = 1
    , image = "illustration_5-2.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "That you will quickly walk your “prisoners” past the guards while you are still disguised as a General."
        , "That all of you will take a pill, become birds, and fly out the window to the forest and safety."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 6.2 -- 10h
        , 9.8 -- 7b
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,
    -- 7a
    { id = 6.1
    , heading = "Fulfilling the Quest"
    , subheading = "Rescuing your friends"
    , storyChapter = chapter2
    , storyPhaseChapter = 2
    , description = 
      """
  On your way out you pass near the Warlord’s bedroom where he lays sleeping protected 
  by two guards. You decide:      
      """
    , pillsLeft = 3
    , transformations = 2
    , image = "illustration_6-1.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "To walk past and continue your escape."
        , "Transform all your friends into Generals and kill the Warlord by surprise."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 7.1 -- 8a
        , 7.2 -- 8b
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }

  , -- 10h 
    { id = 9.8
    , heading = "Adjusting to Normal Life"
    , subheading = ""
    , storyChapter = chapter3
    , storyPhaseChapter = 3
    , description = 
      """
  You get home safely. But your village is soon attacked by the Warlord’s bandits and destroyed. You are captured and enslaved and the Warlord steals the last pill you have left.
      """
    , pillsLeft = 1
    , transformations = 2
    , image = "illustration_9-8.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ 
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 
        ]

    -- Button
    , buttonLabel = "Start Again"

    -- The button event description appears above the button
    , buttonEventDescription = "Your quest is over. Did it end the way you wanted?"

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 1.1
    }
  ,
    -- 7b
    { id = 6.2
    , heading = "Fulfilling the Quest"
    , subheading = "Rescuing your friends"
    , storyChapter = chapter2
    , storyPhaseChapter = 2
    , description = 
      """
  On your way out you pass near the Warlord’s bedroom where he lays sleeping protected 
  by two guards. You decide:      
      """
    , pillsLeft = 4
    , transformations = 1
    , image = "illustration_6-1.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "To walk past and continue your escape."
        , "Transform all your friends into Generals and kill the Warlord by surprise."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 7.3 -- 8c
        , 7.4 -- 8d
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,
    -- 8a
    { id = 7.1
    , heading = "Magic Flight"
    , subheading = "Escaping the castle"
    , storyChapter = chapter2
    , storyPhaseChapter = 3
    , description = 
      """
  The pill is starting to wear off. You only have a minute or two left and you 
  are not out of the castle yet. You decide:     
      """
    , pillsLeft = 3
    , transformations = 2
    , image = "illustration_7-1.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "That all of you should take a pill and fly out as birds. But this would be your last transformation so you must live the rest of your life as a bird."
        , "That your two friends should each take a pill and fly to safety as birds. You will try running out of the castle while you are still disguised as a General."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 9.1 -- 10a
        , 8.1 -- 9a
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,
    -- 8b
    { id = 7.2
    , heading = "Magic Flight"
    , subheading = ""
    , storyChapter = chapter2
    , storyPhaseChapter = 3
    , description = 
      """
  Two guards rush into the bedroom to confront you three over the dead body of the Warlord. You decide:   
      """
    , pillsLeft = 1
    , transformations = 2
    , image = "illustration_7-2.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "To kill the guards and take the last pill and become the Warlord yourself."
        , "To kill the guards and offer the one remaining pill to one of your two friends."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 8.2 -- 9b
        , 8.3 -- 9c
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,
    -- 8c
    { id = 7.3
    , heading = "Magic Flight"
    , subheading = "Escaping the castle"
    , storyChapter = chapter2
    , storyPhaseChapter = 3
    , description = 
      """
  The pill is starting to wear off. You only have a minute or two left and you are not out of the castle yet. You decide:   
      """
    , pillsLeft = 4
    , transformations = 1
    , image = "illustration_7-3.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "That all three of you take a pill to transform into Generals."
        , "That all three of you take a pill to transform into birds."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 8.4 -- 9d
        , 8.5 -- 9e
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,
    -- 8d
    { id = 7.4
    , heading = "Magic Flight"
    , subheading = ""
    , storyChapter = chapter2
    , storyPhaseChapter = 3
    , description = 
      """
  Two guards rush into the bedroom to confront you three over the dead body of the Warlord. You decide:   
      """
    , pillsLeft = 1
    , transformations = 2
    , image = "illustration_7-2.png" -- Same image used as 7.2

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "kill the guards and take the last pill and become the Warlord yourself."
        , "kill the guards and offer the one remaining pill to your two friends."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 8.6 -- 9f
        , 8.7 -- 9g
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,
    -- 9a
    { id = 8.1
    , heading = "Returning Home"
    , subheading = ""
    , storyChapter = chapter2
    , storyPhaseChapter = 3
    , description = 
      """
  Your disguise wears off just before you can escape the castle. You will certainly be captured and killed 
  unless you can transform again. But you have already taken 2 pills so whatever you choose to become will 
  be your form for the rest of your life. You decide:   
      """
    , pillsLeft = 1
    , transformations = 2
    , image = "illustration_7-3.png" -- Same image used as 7.3

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "To become a bird and escape."
        , "To become the Warlord, kill the Generals, and attempt to stop the evil."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 9.2 -- 10b
        , 9.3 -- 10c
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,
    -- 9b
    { id = 8.2
    , heading = "Returning Home"
    , subheading = ""
    , storyChapter = chapter2
    , storyPhaseChapter = 3
    , description = 
      """
  Your friends have reverted back to their normal form but you are now disguised as the Warlord. 
  You order your generals to:  
      """
    , pillsLeft = 0
    , transformations = 3
    , image = "illustration_8-2.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "Release your two friends safely back to their village."
        , "Release your two friends safely back to their village then have the generals executed as conspirators."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 9.4 -- 10d
        , 9.5 -- 10e
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,
    -- 9c
    { id = 8.3
    , heading = "Returning Home"
    , subheading = ""
    , storyChapter = chapter2
    , storyPhaseChapter = 3
    , description = 
      """
  You and your friends decide that:  
      """
    , pillsLeft = 1
    , transformations = 2
    , image = "illustration_7-3.png" -- Same image as 7.3

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "One of them will take the last pill and fly away to save themself."
        , "One of them will take the last pill to become a General."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 9.6 -- 10f
        , 9.7 -- 10g
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,
    -- 9d
    { id = 8.4
    , heading = "Returning Home"
    , subheading = ""
    , storyChapter = chapter2
    , storyPhaseChapter = 3
    , description = 
      """
  Disguised as Generals you three decide to: 
      """
    , pillsLeft = 1
    , transformations = 2
    , image = "illustration_8-4.png" 

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "Escape the castle and flee back to your village."
        , "Go back and kill the Warlord in his bed, then one of your friends takes the last pill to temporarily become a General."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 9.8 -- 10f
        , 9.9 -- 10g
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,
    -- 9e
    { id = 8.5
    , heading = "Returning Home"
    , subheading = ""
    , storyChapter = chapter2
    , storyPhaseChapter = 3
    , description = 
      """
  As birds you decide to fly out of the castle into the forest where you all safely 
  revert back to human form. With one pill remaining you decide to: 
      """
    , pillsLeft = 2
    , transformations = 2
    , image = "illustration_8-5.png" 

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "Not take it and journey back to your village."
        , "Take the last pill and transform permanently into the Warlord. Your friends journey back to the village."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 9.8 -- 10h
        , 9.11 -- 10j
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,
    -- 9f
    { id = 8.6
    , heading = "Returning Home"
    , subheading = ""
    , storyChapter = chapter2
    , storyPhaseChapter = 3
    , description = 
      """
  Your friends have reverted back to their normal form but you are now permanently 
  transformed into the Warlord. You order your generals to:
      """
    , pillsLeft = 0
    , transformations = 3
    , image = "illustration_8-2.png" -- Same image as 8.2 

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "Release your two friends safely back to their village."
        , "Release your two friends safely back to their village then have the generals executed as conspirators."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 9.4 -- 10d
        , 9.5 -- 10e
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }
  ,
    -- 9g
    { id = 8.7
    , heading = "Returning Home"
    , subheading = ""
    , storyChapter = chapter2
    , storyPhaseChapter = 3
    , description = 
      """
  With only one pill remaining, you and your friends decide that:
      """
    , pillsLeft = 1
    , transformations = 2
    , image = "illustration_7-3.png" -- Same image as 7.3

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "One of them will take it and fly away to save themself."
        , "One of them will take it to become a General."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 9.6 -- 10f
        , 9.7 -- 10g
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }

  , -- 10a 
    { id = 9.1
    , heading = "Adjusting to Normal Life"
    , subheading = ""
    , storyChapter = chapter3
    , storyPhaseChapter = 3
    , description = 
      """
  You all fly safely to the forest where your friends revert back to human form. 
  But you are now a bird for the rest of your life. You safely guide your friends back 
  home only to find your village is under attack. Your friends are eventually captured and enslaved. 
      """
    , pillsLeft = 0
    , transformations = 3
    , image = "illustration_9-1.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ 
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 
        ]

    -- Button
    , buttonLabel = "Start Again"

    -- The button event description appears above the button
    , buttonEventDescription = "Your quest is over. Did it end the way you wanted?"

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 1.1
    }
  ,
    -- 7b
    { id = 6.2
    , heading = "Fulfilling the Quest"
    , subheading = "Rescuing your friends"
    , storyChapter = chapter2
    , storyPhaseChapter = 2
    , description = 
      """
  On your way out you pass near the Warlord’s bedroom where he lays sleeping protected 
  by two guards. You decide:      
      """
    , pillsLeft = 1
    , transformations = 1
    , image = "illustration_6-1.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ "To walk past and continue your escape."
        , "Transform all your friends into Generals and kill the Warlord by surprise."
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 7.3 -- 8c
        , 7.4 -- 8d
        ]

    -- Button
    , buttonLabel = ""

    -- The button event description appears above the button
    , buttonEventDescription = ""

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 0
    }

  , -- 10b 
    { id = 9.2
    , heading = "Adjusting to Normal Life"
    , subheading = ""
    , storyChapter = chapter3
    , storyPhaseChapter = 3
    , description = 
      """
  You escape into the forest and make your way home in the body of a bird. You return to 
  find your village in ruins and everyone you knew either dead or enslaved. You live 
  out the rest of your life as a bird. 
      """
    , pillsLeft = 0
    , transformations = 3
    , image = "illustration_9-2.png"

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ 
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 
        ]

    -- Button
    , buttonLabel = "Start Again"

    -- The button event description appears above the button
    , buttonEventDescription = "Your quest is over. Did it end the way you wanted?"

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 1.1
    }

  , -- 10c 
    { id = 9.3
    , heading = "Adjusting to Normal Life"
    , subheading = ""
    , storyChapter = chapter3
    , storyPhaseChapter = 3
    , description = 
      """
  You live in the castle as the imposter Warlord and rule with absolute authority. 
  You change the laws and prevent the destruction of your village. Your family and 
  friends are safe, but you are forever doomed to live out your life in the body of the Warlord.
      """
    , pillsLeft = 0
    , transformations = 3
    , image = "illustration_8-2.png" -- same image as 8.2

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ 
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 
        ]

    -- Button
    , buttonLabel = "Start Again"

    -- The button event description appears above the button
    , buttonEventDescription = "Your quest is over. Did it end the way you wanted?"

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 1.1
    }

  , -- 10d 
    { id = 9.4
    , heading = "Adjusting to Normal Life"
    , subheading = ""
    , storyChapter = chapter3
    , storyPhaseChapter = 3
    , description = 
      """
  You must live your life disguised as the Warlord, but your ruthless Generals soon kill 
  you so that they can take over. Your village is eventually destroyed and your family and friends enslaved.
      """
    , pillsLeft = 0
    , transformations = 3
    , image = "illustration_9-4.png" 

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ 
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 
        ]

    -- Button
    , buttonLabel = "Start Again"

    -- The button event description appears above the button
    , buttonEventDescription = "Your quest is over. Did it end the way you wanted?"

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 1.1
    }

  , -- 10e 
    { id = 9.5
    , heading = "Adjusting to Normal Life"
    , subheading = ""
    , storyChapter = chapter3
    , storyPhaseChapter = 3
    , description = 
      """
  You live in the castle as the imposter Warlord. Your evil Generals have been killed so you 
  can rule with absolute authority. You change the laws and prevent the destruction of your village. 
  Your family and friends are safe, but you must live out your life in the body of the Warlord.
      """
    , pillsLeft = 0
    , transformations = 3
    , image = "illustration_8-2.png" -- same image as 8.2

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ 
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 
        ]

    -- Button
    , buttonLabel = "Start Again"

    -- The button event description appears above the button
    , buttonEventDescription = "Your quest is over. Did it end the way you wanted?"

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 1.1
    }

  , -- 10f 
    { id = 9.6
    , heading = "Adjusting to Normal Life"
    , subheading = ""
    , storyChapter = chapter3
    , storyPhaseChapter = 3
    , description = 
      """
  Your friend saves themself and makes it into the forest. When they revert back to 
  human form they run to the village to get help. But the village is under attack and 
  there is no one left to help storm the castle. Eventually they are enslaved and the 
  village is destroyed by the Warlord.
      """
    , pillsLeft = 0
    , transformations = 2
    , image = "illustration_9-1.png" -- same image as 9.1

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ 
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 
        ]

    -- Button
    , buttonLabel = "Start Again"

    -- The button event description appears above the button
    , buttonEventDescription = "Your quest is over. Did it end the way you wanted?"

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 1.1
    }

  , -- 10g 
    { id = 9.7
    , heading = "Adjusting to Normal Life"
    , subheading = ""
    , storyChapter = chapter3
    , storyPhaseChapter = 3
    , description = 
      """
  Disguised as a General, your friend leads you two out of the castle as his prisoners. 
  All of you escape safely back to your village. But your village is eventually 
  destroyed and you and your friends are enslaved.
      """
    , pillsLeft = 0
    , transformations = 2
    , image = "illustration_9-7.png" 

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ 
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 
        ]

    -- Button
    , buttonLabel = "Start Again"

    -- The button event description appears above the button
    , buttonEventDescription = "Your quest is over. Did it end the way you wanted?"

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 1.1
    }

  , -- 10j 
    { id = 9.11
    , heading = "Adjusting to Normal Life"
    , subheading = ""
    , storyChapter = chapter3
    , storyPhaseChapter = 3
    , description = 
      """
  Permanently transformed into the Warlord, you find the army of bandits sent to destroy the 
  village and convince them to instead help you fight off a coup by your traitorous generals. 
  You invade the castle and kill all the generals. You are now the supreme ruler and pass 
  laws to save your village. 
      """
    , pillsLeft = 0
    , transformations = 3
    , image = "illustration_9-11.png" 

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ 
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 
        ]

    -- Button
    , buttonLabel = "Start Again"

    -- The button event description appears above the button
    , buttonEventDescription = "Your quest is over. Did it end the way you wanted?"

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 1.1
    }

  , -- 10i 
    { id = 9.9
    , heading = "Adjusting to Normal Life"
    , subheading = ""
    , storyChapter = chapter3
    , storyPhaseChapter = 3
    , description = 
      """
  Disguised as a General, your friend leads you two out of the castle as his prisoners. 
  All of you escape safely back to your village. But your village is eventually destroyed 
  and you and your friends are enslaved.
      """
    , pillsLeft = 0
    , transformations = 2
    , image = "illustration_9-9.png" 

    -- `alignment` can be "top" or "left"
    , alignment = "top"

    -- Choices: Only add these if this is a choice type page.
    -- Adding more than 1 choice in the array flags this as being a
    -- multiple choice type page  
    , choices = 
        [ 
        ]

    -- The `choiceEvents` represent the story ID numbers that each choice 
    -- above should link to
    , choiceLinks = 
        [ 
        ]

    -- Button
    , buttonLabel = "Start Again"

    -- The button event description appears above the button
    , buttonEventDescription = "Your quest is over. Did it end the way you wanted?"

    -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
    , buttonEventType = "any"

    -- The page that the button should link to.
    -- (Set it to 0 if there is no link)
    , buttonLink = 1.1
    }
  ]


pageOne : Page
pageOne = 
  { id = 1.1
  , heading = "Adventure - From Data"
  , subheading = "The Quest Begins - From Data"
  , storyChapter = chapter1
  , storyPhaseChapter = 1
  , description = 
      """
        From data: Lorem ipsum dolor sit amet, 
        volutpat eros massa ut, vel semper bibendum pharetra fringilla ullamcorper cras, 
        volutpat eros massa ut, vel semper bibendum pharetra fringilla ullamcorper cras, 
        volutpat eros massa ut, vel semper bibendum pharetra fringilla ullamcorper cras, 
      """
  , pillsLeft = 5
  , transformations = 0
  , image = "test.png"
  , alignment = "left"

  -- Choices: Only add these if this is a choice type page.
  -- Adding more than 1 choice in the array flags this as being a
  -- multiple choice type page  
  , choices = 
      [ "Data choice one."
      , "Data choice two" 
      , "Data choice three"
      ]
  , choiceLinks = 
      [ 1.1
      , 1.2
      ]

  -- Button
  , buttonLabel = "Data label"
  , buttonEventDescription = "Data: Click the button to perform an event"
  , buttonEventType = "gameover"
  , buttonLink = 1.1
  }

