load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")

BOAT_SERVER_URL = "http://localhost:5000/get_bridge_status"


def main():
    response = http.get(BOAT_SERVER_URL)

    if response.status_code != 200:
        fail("Boat status request failed with status %d", response.status_code)

    # Children we render in a column
    boatinfoChildren = []
    bannerChildren = []
    statusColumn = []

    # Boat Icon
    imgBase64 = base64.decode("iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAhGVYSWZNTQAqAAAACAAFARIAAwAAAAEAAQAAARoABQAAAAEAAABKARsABQAAAAEAAABSASgAAwAAAAEAAgAAh2kABAAAAAEAAABaAAAAAAAAAEgAAAABAAAASAAAAAEAA6ABAAMAAAABAAEAAKACAAQAAAABAAAADKADAAQAAAABAAAADAAAAADgNpdeAAAACXBIWXMAAAsTAAALEwEAmpwYAAABWWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNi4wLjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyI+CiAgICAgICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3JpZW50YXRpb24+CiAgICAgIDwvcmRmOkRlc2NyaXB0aW9uPgogICA8L3JkZjpSREY+CjwveDp4bXBtZXRhPgoZXuEHAAAB6klEQVQoFWVQTWgTQRR+b3Z21zSbnzalpWIDhaiXKtocPEqqnpSKF/EknvRQDwpe2osLQo+C1EuOohcbRJBWhSILHsSKikilUGlCDWyXpInZpPnbv3Fmi1DxzWG+me9n3jyAA2UYBhXHawDjjDFygPofGgYLxUtfKpk7t2a/ccWEUOn6v8YwRedpuRx6T40fGbfffq2NjqeWPm4v7hswELzAokJwfx8DQ5rXYskjLau8k86kL64WnSeC0hF4hwwFJgZjFBGDF5/MucnssWlgQVNRIxG71nFHxuTry+uNPACyQqEQhtMcordS8i7LkqT/tsF2Cem1KA34LllV6NCodvPBq7WvV2fO5A3doOEzb+8+zMjP343smiu0dOPeFXV363z07EzTLpeL3Y2N4qj5qzqd+Pzm6If+VmiwZs/NDSWHF/acoCmB58uSPOB6nT0EwkBSok6719p+vHwhC/A97OvlqUtrHUepxFUtzmKHByN9T40HkRQm0sOKklAqx6fms4/yDfFpvL24eoKlT75PxYai1HeohwhqwPgckPUR+HzA6yqHelA31XJp/TR9tlkjcm0nVh3wEALfB4k7mMjiJRr2GQwSotntujNWb1CqWeZmktCpia7FaZcvAFmIef3FLr9xe3XWsKyffwC2k80ucjBLQQAAAABJRU5ErkJggg==")
    bannerChildren.append(render.Image(src=imgBase64))

    # Avaliability Status
    statusColumn.append(render.Text(content=response.json()[
                        "status_titles"][0], font="tom-thumb", color=response.json()["background_color"]))
    if len(response.json()["status_titles"]) > 1:
       statusColumn.append(render.Text(content=response.json()[
                           "status_titles"][1], font="tom-thumb", color=response.json()["background_color"]))
    bannerChildren.append(render.Column(children=statusColumn,))
    boatinfoChildren.append(render.Row(
        children=bannerChildren, expanded=True, main_align="space_evenly"))

    # Anticipated Next Boat Time
    boatinfoChildren.append(render.WrappedText(content=response.json(
    )["first_item_data"], linespacing=0, font="tom-thumb", align="center"))

    return render.Root(
        child=render.Column(
            children=boatinfoChildren,
            cross_align="center",
            main_align="space_evenly",
            expanded=True
        ),

    )
