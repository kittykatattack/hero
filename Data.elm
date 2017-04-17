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


type alias Inventory =
    List Item


inventory : Inventory
inventory =
    [ { name = "Magic Pills"
      , image = "pill.png"
      , quantity = 0
      }
    , { name = "Transformations"
      , image = "wand.png"
      , quantity = 0
      }
    ]



-- STORY METADATA
-- A list of three markdown elements that describe the the main
-- information pages in the game (`infoPageOne`, `infoPageTwo`
-- and `infoPageThree`).


infoPageOne =
    """\x0D
  ## Phase I: The Departure\x0D
\x0D
  A. **Call to adventure** – the hero learns what he/she must do.\x0D
\x0D
  B. **Supernatural aid** – something magical happens that gives the hero supernatural powers and/or weapons\x0D
  \x0D
  C. **The Journey begins** – the hero faces his or her fears and takes the first steps into the unknown.    \x0D
  """


infoPageTwo =
    """\x0D
  ## Phase II: The Journey \x0D
\x0D
  A. **Tests and ordeals** – the hero has to face many challenges and ordeals along the way. In doing so, the hero tests the strength of their character.\x0D
  \x0D
  B. **Confronting their goal** – eventually the hero faces the thing they have been looking for. They must either defeat it or make peace with it\x0D
  \x0D
  C. **Transformation** – the character of the hero is forever changed by their experiences along the journey. It could be by falling in love or by realizing something about the true nature of themselves or the world.\x0D
  \x0D
  D. **Fulfilling the quest** – the goal of the quest has been achieved.  The hero feels purified and renewed.\x0D
  """


infoPageThree =
    """\x0D
  ## Phase III: The Return \x0D
\x0D
  A. **The "Magic Flight"** – the journey back home often involves some magic or special event to break the spell of the quest.\x0D
  \x0D
  B. **Returning home** - to face family and friends again, but now as a changed person, perhaps also to seek revenge or to fulfill a prophecy.\x0D
  \x0D
  C. **Adjusting to a normal life** - finding a way to return to living as a normal person again after the adventures of the heroic journey.\x0D
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


chapter1 =
    "Phase 1: The Departure"


chapter2 =
    "Phase 2: The Journey"


chapter3 =
    "Phase 3: The Return"


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


type alias ID =
    Float


type alias Page =
    { id :
        ID
        -- Used to identify and link pages together
    , heading :
        String
        -- The main page heading
    , subheading :
        String
        -- The optional subheadin
    , storyChapter :
        String
        -- The chapter that this page belongs to
    , storyPhaseChapter :
        Int
        -- The story phase that the page belongs to (1,2 or 3)
    , description :
        String
        -- Markdown text that describes the Msg
    , pillsLeft :
        Int
        -- The number of Magic Pills the player has at this page
    , transformations :
        Int
        -- The number of transformations the player had made at this page.
    , image :
        String
        -- The page illustration
    , alignment :
        String
        -- How the content box is aligned
    , choices :
        List (String, String)
        -- The text label's for the choices the player has
    , choiceLinks :
        List ID
        -- The page ID's used to link each page
    , buttonLabel :
        String
        -- The label for the button
    , buttonEventDescription :
        String
        -- Text that describes what the button does
    , buttonEventType :
        String
        -- "next", "Msg", "question", "gameover",
    , buttonLink :
        ID
        -- The ID of the page that the button should link to
    }


type alias Story =
    List Page



-- The data for all the story pages


story : Story
story =
    [ { id = 1.1
      , heading = "Introduction"
      , subheading = ""
      , storyChapter = chapter1
      , storyPhaseChapter = 1
      , description =
            """\x0D
  You are 19 years old and bored with life in your small medieval town. \x0D
  Your parents run a general store and your job is to make deliveries to \x0D
  their wealthy customers. One day your parents send you out on a long \x0D
  delivery that will take several days journey to complete. They suggest \x0D
  you invite some friends along for protection and to make the journey \x0D
  more fun. You choose your three best friends to take the trip with you. \x0D
  """
      , pillsLeft = 0
      , transformations = 0
      , image = "illustration_1-1.png"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Start"
            -- The button event description appears above the button
      , buttonEventDescription =
            "Start your journey"
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 1.2
      }
    , { id = 1.2
      , heading = "Call to Adventure"
      , subheading = ""
      , storyChapter = chapter1
      , storyPhaseChapter = 1
      , description =
            """\x0D
  Along the way your party is attacked by bandits on horseback. \x0D
  They kill one of your friends and club you on the head. \x0D
  They leave you for dead and kidnap your other two friends to hold them for ransom.\x0D
      """
      , pillsLeft = 0
      , transformations = 0
      , image = "illustration_1-2.png"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Next"
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 1.3
      }
    , { id = 1.3
      , heading = "Call to Adventure"
      , subheading = ""
      , storyChapter = chapter1
      , storyPhaseChapter = 1
      , description   =
            """\x0D
  As you wake up alone and injured in the dark forest you hear something \x0D
  approaching. You constantly either try to hide from it or confront it. What do you do?\x0D
      """
      , pillsLeft = 0
      , transformations = 0
      , image = "illustration_1-4.png"
      , alignment =
            "left"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1      choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "Try to hide from it")
            , ("B", "Confront it")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 1.4
              -- Game Over
            , 2.1
              -- Supernatural Aid and Quest begins
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , { id = 1.4
      , heading = "Call to Adventure"
      , subheading = ""
      , storyChapter = chapter1
      , storyPhaseChapter = 1
      , description =
            """\x0D
  **You die alone in a dirt hole under a tree.**\x0D
      """
      , pillsLeft = 0
      , transformations = 0
      , image = "illustration_1-4.png"
      , alignment =
            "left"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Go Back"
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "gameover"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 1.3
      }
    , { id = 2.1
      , heading = "Supernatural Aid and Quest Begins"
      , subheading = "The Story (page 1 of 5)"
      , storyChapter = chapter1
      , storyPhaseChapter = 1
      , description =
            """\x0D
  You are greeted by a shimmering spirit who heals your injuries and tells \x0D
  you that your friends are being held in the Warlord’s castle. She also tells \x0D
  you a mysterious story about a deadly threat to your entire village along with \x0D
  a prophecy explaining how it can be saved.  \x0D
      """
      , pillsLeft = 0
      , transformations = 0
      , image = "illustration_2-1.png"
      , alignment =
            "left"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Next"
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 2.2
      }
    , { id = 2.2
      , heading = "Supernatural Aid and Quest Begins"
      , subheading = "The Story (page 2 of 5)"
      , storyChapter = chapter1
      , storyPhaseChapter = 1
      , description =
            """\x0D
 Before you were born, your village went through very hard times. People were starving and \x0D
 all seemed lost. In desperation, they agreed to a secret deal with the evil Warlord. He \x0D
 promised them prosperity for 20 years but in return they would owe him a fortune. If the \x0D
 debt were not paid in full by the 20th anniversary, the evil Warlord and his bandits would \x0D
 destroy the village and kill or enslave all the young people. The only way to prevent \x0D
 losing their children was to pay him off or destroy him.\x0D
      """
      , pillsLeft = 0
      , transformations = 0
      , image = "illustration_2-2.png"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Next"
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 2.3
      }
    , { id = 2.3
      , heading = "Supernatural Aid and Quest Begins"
      , subheading = "The Story (page 3 of 5)"
      , storyChapter = chapter1
      , storyPhaseChapter = 1
      , description =
            """\x0D
  The villagers thought that they could raise the money in the years of \x0D
  prosperity promised by the Warlord. Their riches should be more than \x0D
  enough to pay him back. But several unexpected disease epidemics set them \x0D
  back. After 20 years, they did not have enough to pay the Warlord his ransom. \x0D
  Time was up and in a few days the Warlord wanted his payment. Knowing this, \x0D
  your parents sent you away on an errand far outside the village in the hopes \x0D
  you could escape the fate of capture and enslavement.\x0D
      """
      , pillsLeft = 0
      , transformations = 0
      , image = "illustration_2-3.png"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Next"
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 2.4
      }
    , { id = 2.4
      , heading = "Supernatural Aid and Quest Begins"
      , subheading = "The Story (page 4 of 5)"
      , storyChapter = chapter1
      , storyPhaseChapter = 1
      , description =
            """\x0D
  The Gods prophesized that the Warlord could be only be destroyed by his most \x0D
  trusted generals acting together to kill him. But he was constantly surrounded \x0D
  by his most loyal generals. None seemed willing to betray him. It was unlikely \x0D
  this prophecy could ever come true.\x0D
      """
      , pillsLeft = 0
      , transformations = 0
      , image = "illustration_2-4.png"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Next"
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 3.1
      }
    , { id = 3.1
      , heading = "Supernatural Aid and Quest Begins"
      , subheading = "The Story (page 5 of 5)"
      , storyChapter = chapter1
      , storyPhaseChapter = 1
      , description =
            """\x0D
  The spirit also gives you 5 magic pills. Each pill temporarily turns you into \x0D
  someone or something else for about 15 minutes. When the pill wears off you \x0D
  quickly revert back to being yourself. **But be warned! Anyone who takes a pill \x0D
  more than twice will remain what they transformed into**. If you take a pill for \x0D
  a third time, you can never go back to being who you were. You are forever \x0D
  changed and must live out your life in your new form, whatever that may be - \x0D
  a bird, a bandit, or a king. After hearing the spirit’s story, what do you decide to do?\x0D
      """
      , pillsLeft = 5
      , transformations = 0
      , image =
            "illustration_3-1.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "Run home to save your parents.")
            , ("B", "Accept the magic pills and begin journey.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 3.2
            , 4.1
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , { id = 3.2
      , heading = "Supernatural Aid and Quest Begins"
      , subheading = ""
      , storyChapter = chapter1
      , storyPhaseChapter = 1
      , description =
            """\x0D
  **You return home and are killed by the bandits** \x0D
      """
      , pillsLeft = 5
      , transformations = 0
      , image =
            "illustration_3-2.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Go Back"
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "gameover"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 3.1
      }
    , { id = 4.1
      , heading = "Trial #1"
      , subheading = ""
      , storyChapter = chapter2
      , storyPhaseChapter = 2
      , description =
            """\x0D
  You are travelling alone through the forest on a mission to rescue your friends. \x0D
  Along the way you meet a talking crow who says he knows a safe route to the Warlord’s \x0D
  castle. He can fly ahead and lead you there quickly. But there is a price. \x0D
  He wants one of your magic pills.\x0D
      """
      , pillsLeft = 5
      , transformations = 0
      , image =
            "illustration_4-1.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "You think the crow is trying to trick you so you tell him to leave you alone and you make your way on your own.")
            , ("B", "You accept the crow’s offer and he starts to lead you.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 4.3
            , 4.2
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , { id = 4.2
      , heading = "Trial #1"
      , subheading = ""
      , storyChapter = chapter2
      , storyPhaseChapter = 2
      , description =
            """\x0D
  **The crow leads you into a trap and you are killed by bandits. The crow steals all of your pills.**\x0D
      """
      , pillsLeft = 0
      , transformations = 0
      , image =
            "illustration_4-2.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Go Back"
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "gameover"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 4.1
      }
    , { id = 4.3
      , heading = "Trial #2"
      , subheading = ""
      , storyChapter = chapter2
      , storyPhaseChapter = 2
      , description =
            """\x0D
  In the evening, as it is getting dark, you are alone and stumbling along the forest trail. \x0D
  You hear a camp of bandits and see their fires in the distance. You think you can hear \x0D
  them talking about your friends but aren’t sure.      \x0D
      """
      , pillsLeft = 5
      , transformations = 0
      , image =
            "illustration_4-3.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "You crawl to the edge of their camp, hiding in the trees just beyond the light of their fires, to listen to them.")
            , ("B", "You decide to skirt around the camp and avoid them.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 4.4
            , 4.5
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , { id = 4.4
      , heading = "Trial #2"
      , subheading = ""
      , storyChapter = chapter2
      , storyPhaseChapter = 2
      , description =
            """\x0D
  **You stumble upon a couple of guards out on patrol. They kill you.**\x0D
      """
      , pillsLeft = 5
      , transformations = 0
      , image =
            "illustration_4-4.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Go Back"
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "gameover"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 4.3
      }
    , -- 5
      { id = 4.5
      , heading = "Trial #3"
      , subheading = ""
      , storyChapter = chapter2
      , storyPhaseChapter = 2
      , description =
            """\x0D
  You overhear where your friends are being held. It is in the tower of the heavily guarded castle. \x0D
  The castle is about a 6 hour hike through the forest and then across some open fields.\x0D
\x0D
  Unfortunately, the guards on the castle walls will be able to see you coming from any direction \x0D
  as you cross the open fields towards them. When you reach the edge of the fields surrounding \x0D
  the castle you must find a way to get past the guards. You decide to take one of your 5 magic \x0D
  pills and temporarily become:      \x0D
      """
      , pillsLeft = 5
      , transformations = 0
      , image =
            "illustration_4-5.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "A small bird who can fly over the walls and into the castle tower undetected by the guards.")
            , ("B", "One of the senior generals so you can walk past the guards and into the prison tower where your friends are held.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 5.1
              -- 6a
            , 5.2
              -- 6b
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , -- 6a
      { id = 5.1
      , heading = "Confronting the goal"
      , subheading = "Rescuing your friends"
      , storyChapter = chapter2
      , storyPhaseChapter = 2
      , description =
            """\x0D
  You land beside your friends but have to wait until your bird shape wears off. \x0D
  When you reappear as yourself, you untie your two friends and discuss an escape \x0D
  plan with them. You decide:      \x0D
      """
      , pillsLeft = 4
      , transformations = 1
      , image =
            "illustration_5-1.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "that all three of you will take a pill, become small birds, and fly out the window to the forest and safety.")
            , ("B", "only you will take a pill and become a general and walk your “prisoners” past the guards.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 9.8
              -- 7a
            , 6.1
              -- 10h
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , -- 6b
      { id = 5.2
      , heading = "Confronting the goal"
      , subheading = "Rescuing your friends"
      , storyChapter = chapter2
      , storyPhaseChapter = 2
      , description =
            """\x0D
  You untie your two surprised friends, explain who you are, and quickly hatch \x0D
  an escape plan. You decide:       \x0D
      """
      , pillsLeft = 4
      , transformations = 1
      , image =
            "illustration_5-2.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "That you will quickly walk your “prisoners” past the guards while you are still disguised as a General.")
            , ("B", "That all of you will take a pill, become birds, and fly out the window to the forest and safety.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 6.2
              -- 10h
            , 9.8
              -- 7b
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , -- 7a
      { id = 6.1
      , heading = "Fulfilling the Quest"
      , subheading = "Rescuing your friends"
      , storyChapter = chapter2
      , storyPhaseChapter = 2
      , description =
            """\x0D
  On your way out you pass near the Warlord’s bedroom where he lays sleeping protected \x0D
  by two guards. You decide:      \x0D
      """
      , pillsLeft = 3
      , transformations = 2
      , image =
            "illustration_6-1.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "To walk past and continue your escape.")
            , ("B", "Transform all your friends into Generals and kill the Warlord by surprise.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 7.1
              -- 8a
            , 7.2
              -- 8b
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
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
            """\x0D
  You get home safely. But your village is soon attacked by the Warlord’s bandits and destroyed. You are captured and enslaved and the Warlord steals the last pill you have left.\x0D
      """
      , pillsLeft = 1
      , transformations = 2
      , image =
            "illustration_9-8.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Start Again"
            -- The button event description appears above the button
      , buttonEventDescription =
            "Your quest is over. Did it end the way you wanted?"
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 1.1
      }
    , -- 7b
      { id = 6.2
      , heading = "Fulfilling the Quest"
      , subheading = "Rescuing your friends"
      , storyChapter = chapter2
      , storyPhaseChapter = 2
      , description =
            """\x0D
  On your way out you pass near the Warlord’s bedroom where he lays sleeping protected \x0D
  by two guards. You decide:      \x0D
      """
      , pillsLeft = 4
      , transformations = 1
      , image =
            "illustration_6-1.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "To walk past and continue your escape.")
            , ("B", "Transform all your friends into Generals and kill the Warlord by surprise.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 7.3
              -- 8c
            , 7.4
              -- 8d
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , -- 8a
      { id = 7.1
      , heading = "Magic Flight"
      , subheading = "Escaping the castle"
      , storyChapter = chapter2
      , storyPhaseChapter = 3
      , description =
            """\x0D
  The pill is starting to wear off. You only have a minute or two left and you \x0D
  are not out of the castle yet. You decide:     \x0D
      """
      , pillsLeft = 3
      , transformations = 2
      , image =
            "illustration_7-1.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "That all of you should take a pill and fly out as birds. But this would be your last transformation so you must live the rest of your life as a bird.")
            , ("B", "That your two friends should each take a pill and fly to safety as birds. You will try running out of the castle while you are still disguised as a General.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 9.1
              -- 10a
            , 8.1
              -- 9a
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , -- 8b
      { id = 7.2
      , heading = "Magic Flight"
      , subheading = ""
      , storyChapter = chapter2
      , storyPhaseChapter = 3
      , description =
            """\x0D
  Two guards rush into the bedroom to confront you three over the dead body of the Warlord. You decide:   \x0D
      """
      , pillsLeft = 1
      , transformations = 2
      , image =
            "illustration_7-2.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "To kill the guards and take the last pill and become the Warlord yourself.")
            , ("B", "To kill the guards and offer the one remaining pill to one of your two friends.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 8.2
              -- 9b
            , 8.3
              -- 9c
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , -- 8c
      { id = 7.3
      , heading = "Magic Flight"
      , subheading = "Escaping the castle"
      , storyChapter = chapter2
      , storyPhaseChapter = 3
      , description =
            """\x0D
  The pill is starting to wear off. You only have a minute or two left and you are not out of the castle yet. You decide:   \x0D
      """
      , pillsLeft = 4
      , transformations = 1
      , image =
            "illustration_7-3.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "That all three of you take a pill to transform into Generals.")
            , ("B", "That all three of you take a pill to transform into birds.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 8.4
              -- 9d
            , 8.5
              -- 9e
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , -- 8d
      { id = 7.4
      , heading = "Magic Flight"
      , subheading = ""
      , storyChapter = chapter2
      , storyPhaseChapter = 3
      , description =
            """\x0D
  Two guards rush into the bedroom to confront you three over the dead body of the Warlord. You decide:   \x0D
      """
      , pillsLeft = 1
      , transformations = 2
      , image =
            "illustration_7-2.png"
            -- Same image used as 7.2
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "kill the guards and take the last pill and become the Warlord yourself.")
            , ("B", "kill the guards and offer the one remaining pill to your two friends.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 8.6
              -- 9f
            , 8.7
              -- 9g
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , -- 9a
      { id = 8.1
      , heading = "Returning Home"
      , subheading = ""
      , storyChapter = chapter2
      , storyPhaseChapter = 3
      , description =
            """\x0D
  Your disguise wears off just before you can escape the castle. You will certainly be captured and killed \x0D
  unless you can transform again. But you have already taken 2 pills so whatever you choose to become will \x0D
  be your form for the rest of your life. You decide:   \x0D
      """
      , pillsLeft = 1
      , transformations = 2
      , image =
            "illustration_7-3.png"
            -- Same image used as 7.3
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "To become a bird and escape.")
            , ("B", "To become the Warlord, kill the Generals, and attempt to stop the evil.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 9.2
              -- 10b
            , 9.3
              -- 10c
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , -- 9b
      { id = 8.2
      , heading = "Returning Home"
      , subheading = ""
      , storyChapter = chapter2
      , storyPhaseChapter = 3
      , description =
            """\x0D
  Your friends have reverted back to their normal form but you are now disguised as the Warlord. \x0D
  You order your generals to:  \x0D
      """
      , pillsLeft = 0
      , transformations = 3
      , image =
            "illustration_8-2.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "Release your two friends safely back to their village.")
            , ("B", "Release your two friends safely back to their village then have the generals executed as conspirators.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 9.4
              -- 10d
            , 9.5
              -- 10e
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , -- 9c
      { id = 8.3
      , heading = "Returning Home"
      , subheading = ""
      , storyChapter = chapter2
      , storyPhaseChapter = 3
      , description =
            """\x0D
  You and your friends decide that:  \x0D
      """
      , pillsLeft = 1
      , transformations = 2
      , image =
            "illustration_7-3.png"
            -- Same image as 7.3
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "One of them will take the last pill and fly away to save themself.")
            , ("B", "One of them will take the last pill to become a General.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 9.6
              -- 10f
            , 9.7
              -- 10g
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , -- 9d
      { id = 8.4
      , heading = "Returning Home"
      , subheading = ""
      , storyChapter = chapter2
      , storyPhaseChapter = 3
      , description =
            """\x0D
  Disguised as Generals you three decide to: \x0D
      """
      , pillsLeft = 1
      , transformations = 2
      , image =
            "illustration_8-4.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "Escape the castle and flee back to your village.")
            , ("B", "Go back and kill the Warlord in his bed, then one of your friends takes the last pill to temporarily become a General.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 9.8
              -- 10f
            , 9.9
              -- 10g
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , -- 9e
      { id = 8.5
      , heading = "Returning Home"
      , subheading = ""
      , storyChapter = chapter2
      , storyPhaseChapter = 3
      , description =
            """\x0D
  As birds you decide to fly out of the castle into the forest where you all safely \x0D
  revert back to human form. With one pill remaining you decide to: \x0D
      """
      , pillsLeft = 2
      , transformations = 2
      , image =
            "illustration_8-5.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "Not take it and journey back to your village.")
            , ("B", "Take the last pill and transform permanently into the Warlord. Your friends journey back to the village.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 9.8
              -- 10h
            , 9.11
              -- 10j
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , -- 9f
      { id = 8.6
      , heading = "Returning Home"
      , subheading = ""
      , storyChapter = chapter2
      , storyPhaseChapter = 3
      , description =
            """\x0D
  Your friends have reverted back to their normal form but you are now permanently \x0D
  transformed into the Warlord. You order your generals to:\x0D
      """
      , pillsLeft = 0
      , transformations = 3
      , image =
            "illustration_8-2.png"
            -- Same image as 8.2
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "Release your two friends safely back to their village.")
            , ("B", "Release your two friends safely back to their village then have the generals executed as conspirators.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 9.4
              -- 10d
            , 9.5
              -- 10e
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 0
      }
    , -- 9g
      { id = 8.7
      , heading = "Returning Home"
      , subheading = ""
      , storyChapter = chapter2
      , storyPhaseChapter = 3
      , description =
            """\x0D
  With only one pill remaining, you and your friends decide that:\x0D
      """
      , pillsLeft = 1
      , transformations = 2
      , image =
            "illustration_7-3.png"
            -- Same image as 7.3
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "One of them will take it and fly away to save themself.")
            , ("B", "One of them will take it to become a General.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 9.6
              -- 10f
            , 9.7
              -- 10g
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
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
            """\x0D
  You all fly safely to the forest where your friends revert back to human form. \x0D
  But you are now a bird for the rest of your life. You safely guide your friends back \x0D
  home only to find your village is under attack. Your friends are eventually captured and enslaved. \x0D
      """
      , pillsLeft = 0
      , transformations = 3
      , image =
            "illustration_9-1.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Start Again"
            -- The button event description appears above the button
      , buttonEventDescription =
            "Your quest is over. Did it end the way you wanted?"
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 1.1
      }
    , -- 7b
      { id = 6.2
      , heading = "Fulfilling the Quest"
      , subheading = "Rescuing your friends"
      , storyChapter = chapter2
      , storyPhaseChapter = 2
      , description =
            """\x0D
  On your way out you pass near the Warlord’s bedroom where he lays sleeping protected \x0D
  by two guards. You decide:      \x0D
      """
      , pillsLeft = 1
      , transformations = 1
      , image =
            "illustration_6-1.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            [ ("A", "To walk past and continue your escape.")
            , ("B", "Transform all your friends into Generals and kill the Warlord by surprise.")
            ]
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            [ 7.3
              -- 8c
            , 7.4
              -- 8d
            ]
            -- Button
      , buttonLabel =
            ""
            -- The button event description appears above the button
      , buttonEventDescription =
            ""
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
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
            """\x0D
  You escape into the forest and make your way home in the body of a bird. You return to \x0D
  find your village in ruins and everyone you knew either dead or enslaved. You live \x0D
  out the rest of your life as a bird. \x0D
      """
      , pillsLeft = 0
      , transformations = 3
      , image =
            "illustration_9-2.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Start Again"
            -- The button event description appears above the button
      , buttonEventDescription =
            "Your quest is over. Did it end the way you wanted?"
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
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
            """\x0D
  You live in the castle as the imposter Warlord and rule with absolute authority. \x0D
  You change the laws and prevent the destruction of your village. Your family and \x0D
  friends are safe, but you are forever doomed to live out your life in the body of the Warlord.\x0D
      """
      , pillsLeft = 0
      , transformations = 3
      , image =
            "illustration_8-2.png"
            -- same image as 8.2
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Start Again"
            -- The button event description appears above the button
      , buttonEventDescription =
            "Your quest is over. Did it end the way you wanted?"
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
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
            """\x0D
  You must live your life disguised as the Warlord, but your ruthless Generals soon kill \x0D
  you so that they can take over. Your village is eventually destroyed and your family and friends enslaved.\x0D
      """
      , pillsLeft = 0
      , transformations = 3
      , image =
            "illustration_9-4.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Start Again"
            -- The button event description appears above the button
      , buttonEventDescription =
            "Your quest is over. Did it end the way you wanted?"
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
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
            """\x0D
  You live in the castle as the imposter Warlord. Your evil Generals have been killed so you \x0D
  can rule with absolute authority. You change the laws and prevent the destruction of your village. \x0D
  Your family and friends are safe, but you must live out your life in the body of the Warlord.\x0D
      """
      , pillsLeft = 0
      , transformations = 3
      , image =
            "illustration_8-2.png"
            -- same image as 8.2
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Start Again"
            -- The button event description appears above the button
      , buttonEventDescription =
            "Your quest is over. Did it end the way you wanted?"
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
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
            """\x0D
  Your friend saves themself and makes it into the forest. When they revert back to \x0D
  human form they run to the village to get help. But the village is under attack and \x0D
  there is no one left to help storm the castle. Eventually they are enslaved and the \x0D
  village is destroyed by the Warlord.\x0D
      """
      , pillsLeft = 0
      , transformations = 2
      , image =
            "illustration_9-1.png"
            -- same image as 9.1
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Start Again"
            -- The button event description appears above the button
      , buttonEventDescription =
            "Your quest is over. Did it end the way you wanted?"
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
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
            """\x0D
  Disguised as a General, your friend leads you two out of the castle as his prisoners. \x0D
  All of you escape safely back to your village. But your village is eventually \x0D
  destroyed and you and your friends are enslaved.\x0D
      """
      , pillsLeft = 0
      , transformations = 2
      , image =
            "illustration_9-7.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Start Again"
            -- The button event description appears above the button
      , buttonEventDescription =
            "Your quest is over. Did it end the way you wanted?"
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
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
            """\x0D
  Permanently transformed into the Warlord, you find the army of bandits sent to destroy the \x0D
  village and convince them to instead help you fight off a coup by your traitorous generals. \x0D
  You invade the castle and kill all the generals. You are now the supreme ruler and pass \x0D
  laws to save your village. \x0D
      """
      , pillsLeft = 0
      , transformations = 3
      , image =
            "illustration_9-11.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Start Again"
            -- The button event description appears above the button
      , buttonEventDescription =
            "Your quest is over. Did it end the way you wanted?"
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
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
            """\x0D
  Disguised as a General, your friend leads you two out of the castle as his prisoners. \x0D
  All of you escape safely back to your village. But your village is eventually destroyed \x0D
  and you and your friends are enslaved.\x0D
      """
      , pillsLeft = 0
      , transformations = 2
      , image =
            "illustration_9-9.png"
            -- `alignment` can be "top" or "left"
      , alignment =
            "top"
            -- Choices: Only add these if this is a choice type page.
            -- Adding more than 1 choice in the array flags this as being a
            -- multiple choice type page
      , choices =
            []
            -- The `choiceEvents` represent the story ID numbers that each choice
            -- above should link to
      , choiceLinks =
            []
            -- Button
      , buttonLabel =
            "Start Again"
            -- The button event description appears above the button
      , buttonEventDescription =
            "Your quest is over. Did it end the way you wanted?"
            -- The `buttonEventType` can be "next", "Msg", "question". "any" or "gameover"
      , buttonEventType =
            "any"
            -- The page that the button should link to.
            -- (Set it to 0 if there is no link)
      , buttonLink = 1.1
      }
    ]

pageOne : Page
pageOne =
    { id = 10.1
    , heading = "Adventure - From Data"
    , subheading = "The Quest Begins - From Data"
    , storyChapter = chapter1
    , storyPhaseChapter = 1
    , description =
        """\x0D
        From data: Lorem ipsum dolor sit amet, \x0D
        volutpat eros massa ut, vel semper bibendum pharetra fringilla ullamcorper cras, \x0D
        volutpat eros massa ut, vel semper bibendum pharetra fringilla ullamcorper cras, \x0D
        volutpat eros massa ut, vel semper bibendum pharetra fringilla ullamcorper cras, \x0D
      """
    , pillsLeft = 5
    , transformations = 0
    , image = "test.png"
    , alignment =
        "left"
        -- Choices: Only add these if this is a choice type page.
        -- Adding more than 1 choice in the array flags this as being a
        -- multiple choice type page
    , choices =
        [ ("A", "Data choice one.")
        , ("B", "Data choice two")
        , ("C", "Data choice three")
        ]
    , choiceLinks =
        [ 1.1
        , 1.2
        , 1.3
        ]
        -- Button
    , buttonLabel = "Data label"
    , buttonEventDescription = "Data: Click the button to perform an event"
    , buttonEventType = "gameover"
    , buttonLink = 0
    }
