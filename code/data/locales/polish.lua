-- ~/code/data/locales/polish.lua

return {
    meta = {
        name = "Polski",
        sortOrder = 5,
    },

    common = {
        back = "Wróć",
    },

    shared = {
        creditsValue = "{amount} K$",
    },

    mainMenu = {
        play = "Graj",
        quit = "Wyjdź",
    },

    saveFiles = {
        slot = "Slot {n}",
        loadFile = "Wczytaj zapis",
        resetFile = "Resetuj zapis",
        resetConfirm = "Na pewno?",
        resetDone = "Pa pa!",
        highestTier = "Najwyż. tier: {tier}",
    },

    boxRanch = {
        spawnBox = "Spawnuj Boxa!",
        spawnCooldown = "{time}s",
        autoSpawn = "Auto-spawn ({state})",
        on = "WŁ.",
        off = "WYŁ.",
    },

    upgradeShop = {
        cost = "{amount} Kredytów",
        maxed = "MAX",
    },

    settings = {
        categories = {
            audio = "Dźwięk",
            graphics = "Grafika",
            accessibility = "Dostępność",
        },

        masterVolume = "Głośność",
        soundVolume = "Efekty dźwiękowe",
        trackVolume = "Muzyka",
        muteGame = "Wycisz grę?",

        contrast = "Kontrast",
        gamma = "Gamma",
        fullscreen = "Pełny ekran?",
        vsync = "VSync?",
        uiAnimationsEnabled = "Animacje interfejsu?",
        cursorAnimationsEnabled = "Animacje kursora?",
        transitionsEnabled = "Animacje przejść?",
        particlesEnabled = "Efekty cząsteczkowe?",

        colorblindMode = "Tryb daltonizmu",
        screenFlashEnabled = "Błyski ekranu?",

        language = "Język",

        colorblindModes = {
            none = "Brak",
            protanopia = "Protanopia",
            deuteranopia = "Deuteranopia",
            tritanopia = "Tritanopia",
        },
    },

    upgrades = {
        spawnCooldown = {
            name = "Czas spawnu",
            description = "Skraca czas między spawnami o 0,1s na poziom.",
        },

        spawnTier = {
            name = "Poziom spawnu",
            description = "Zwiększa poziom spawnowanych Boxów o 1 na poziom.",
        },

        autoSpawn = {
            name = "Auto-spawn",
            description = "Dodaje przełącznik automatycznego spawnu Boxów. (Nie działa poza ranczem.)",
        },

        luckyRoll = {
            name = "Szczęśliwy rzut",
            description = "Każdy zespawnowany Box ma szansę awansować o poziom. Każdy poziom zwiększa tę szansę o 10%.",
        },

        multiSpawn = {
            name = "Multi-spawn",
            description = "Spawnuje dodatkowego Boxa na poziom.",
        },

        pullPower = {
            name = "Siła przyciągania",
            description = "Zwiększa siłę przyciągania. Przydatne przy dużych Boxach. Każdy poziom daje +100% siły.",
        },
    },

    boxes = {
        goldenGerald = {
            name = "Golden Gerald",
            description = "Mały, szybki Box, który czasem śmiga po okolicy. Kliknij go, żeby dostać buffa!",
            quote = "Golden Gerald.",
        },

        geraldo = {
            name = "Geraldo",
            description = "Jedna z podróbek, w które może zmienić się Box o' Matter. Ten udaje Geralda. I to kiepsko.",
            quote = "Geraldo.",
        },

        jambo = {
            name = "Jambo",
            description = "Jedna z podróbek, w które może zmienić się Box o' Matter. Ten udaje Jimbo. I to kiepsko.",
            quote = "Co!? Przyłapałeś mnie!?",
        },

        glungus = {
            name = "Glungus",
            description = "Jedna z podróbek, w które może zmienić się Box o' Matter. Ten udaje Glumbo. I to kiepsko.",
            quote = "Hehehe, TĘDY na pewno mnie nie znajdą!",
        },

        -- Normal
        gerald = {
            name = "Gerald",
            description = "No przecież to Gerald! Naprawdę trzeba go przedstawiać? Jest idealny!",
            quote = "Gerald.",
        },

        jimbo = {
            name = "Jimbo",
            description = "Jimbo jest ciągle czymś zszokowany. Zawsze przeraża go to, co zaraz się wydarzy.",
            quote = "CO??",
        },

        glumbo = {
            name = "Glumbo",
            description = "Glumbo ciągle planuje przejąć świat, ale nic z tego, bo wszystkim zdradza swoje plany. To przez niego jego brat Jimbo jest ciągle w szoku.",
            quote = "I właśnie tak przejmę świat!",
        },

        jeremy = {
            name = "Jeremy",
            description = "Jeremy uwielbia przypominać nauczycielowi o pracy domowej. Nikt nie lubi Jeremy'ego.",
            quote = "Eee... właściwie! :nerd:",
        },

        muncher = {
            name = "Muncher",
            description = "Gruby Box, który NA PEWNO zjadł to ciastko.",
            quote = "Nie zjadłem tego ciastka!",
        },

        dylan = {
            name = "Dylan",
            description = "Dylan uwielbia kupować ciuchy w \"Cold Subject\". Nie jest zbyt rozmowny.", -- Backslashes are used to put quotes inside quotes
            quote = "...",
        },

        carlos = {
            name = "Carlos",
            description = "Mega energiczny Box, który uwielbia działać ludziom na nerwy. Irytujący.",
            quote = "HEJ!!!",
        },

        goobsterGoobingtonIII = {
            name = "Goobster Goobington III",
            description = "Ten głupiutki Box uwielbia wystawiać język! Niezły z niego pajac.",
            quote = "Bleeeee!",
        },

        mark = {
            name = "Mark",
            description = "Ten Box w ogóle nie wygląda znajomo... Jest tu nowy, więc z ciekawością obserwuje wszystko dookoła.",
            quote = "O, to jest nowe...",
        },

        frigidWendyhot = {
            name = "Frigid Wendyhot",
            description = "Niesamowicie chłodny sześcian, który najwyraźniej ma tragicznych rodziców. Kto normalny nazwałby dziecko \"Frigid Wendyhot\"? I kto zgolił mu drugą brew?",
            quote = "Siema, bliźniaku?",
        },

        dizzy = {
            name = "Dizzy",
            description = "Box, którego percepcja jest kilka sekund spóźniona względem rzeczywistości. Reaguje na rzeczy, które już się wydarzyły.",
            quote = "Co? cze-?",
        },

        gochged = {
            name = "Gochged",
            description = "Granitowa istota przemieniona w Boxa. To on stworzył wszystkie twarze, które widzisz na Boxach.",
            quote = "Odgłosy skał",
        },

        mtBox = {
            name = "Mt. Box",
            description = "Box, który urósł tak bardzo, że można go uznać za górę! Lepiej chyba nie iść dalej... Chociaż wygląda trochę głupio.",
            quote = "Big back, big back! Big back, big back! Yeah, my back is loaded up with snacks and different foods!",
        },

        unstable = {
            name = "Unstable",
            description = "Ten Box jest tak wielki, że od zewnątrz rozgrzał się do czerwoności! Upchanie takiej ilości materii w jednym miejscu jest nieludzkie.",
            quote = "RAAAAAAAAAHHH!!!",
        },

        transcended = {
            name = "Transcended",
            description = "Box, który poznał prawdę o wszystkim. Nawet o tym, że jest w grze! Zamilkł i znieruchomiał, próbując ogarnąć to wszystko naraz.",
            quote = "...",
        },

        omnibox = {
            name = "Omnibox",
            description = "Hipnotyzujący Box, na którego trudno patrzeć. Wcisnąłeś tyle materii w jedną istotę, że zaczyna się z niej wylewać.",
            quote = "d3N6eXN0a28=",
        },

        devoided = {
            name = "Devoided",
            description = "Złowrogi i niestabilny Box. Jest aż tak wielki, że jego waga spadła poniżej zera! (Nie pytaj jak)",
            quote = "MUAHAHAHAHA!",
        },

        boxOMatter = {
            name = "Box o' Matter",
            description = "Figlarny Box, który uwielbia zmieniać swój kształt. Czasem zmienia się w Boxy niższego poziomu, ale nadal liczy się jako ten sam poziom.",
            quote = "Raz, dwa, trzy! Znajdziesz mnie?",
        },

        greatOldGrumpyOne = {
            name = "Great Old Grumpy One",
            description = "Starożytna kosmiczna istota, która istniała jeszcze przed wszechświatem. Właśnie ucinała sobie najlepszą drzemkę w swoim życiu.",
            quote = "Ja SPAŁEM!!",
        },

        luckrollBox = {
            name = "Luckroll Box",
            description = "Tak szczęśliwy Box, że ciągle oskarżają go o oszukiwanie w różnych grach.",
            quote = "Mówię ci, to szczęście!",
        },

        mellowBox = {
            name = "Mellow Box",
            description = "Beztroski Box, którego nic nie obchodzi. Przypomina do złudzenia twórczynię tej gry.",
            quote = "ta",
        },

        theCollector = {
            name = "The Collector",
            description = "Box, który uwielbia zbierać naklejki i różne drobiazgi. Jest nimi cały obklejony. Są WSZĘDZIE. Jak on jeszcze oddycha?",
            quote = "Trochę wszystkiego, cały czas!",
        },

        glitcherson = {
            name = "Glitcherson",
            description = "Dziwnie wyglądający Box z jeszcze dziwniejszym sposobem pisania. Patrzenie na niego zbyt długo może skończyć się migreną.",
            quote = "H4H4H4H4HH4H4H4H4H4HH4H4H4H4H44444!!!!! J4 K0CH4M 8YĆ N13D0ZN13S13N14!!!! W00H000!!!",
        },
    },
}