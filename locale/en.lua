local Translations = {
    error = {
        fingerprints = 'You\'ve left a fingerprint on the glass',
        minimum_police = 'Minimum of %{value} police needed',
        to_much = 'You have to much in your pockets'
    },
    success = {},
    info = {
        progressbar = 'Detaching the items...',
    },
    general = {
        target_label = 'Start detaching items..',
        drawtextui_grab = '[E] Start detaching items',
        drawtextui_broken = 'All the boxes are empty..'
    }
}

Lang = Locale:new({phrases = Translations})
