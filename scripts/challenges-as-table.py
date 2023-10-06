#!/usr/bin/env python
import argparse
import csv
import json
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Optional


REPO_ROOT = Path(__file__).parent.parent
CHALLENGES_PATH = REPO_ROOT / "assets" / "challenges.json"


@dataclass
class Challenge:
    header: str
    text: str
    coins: int
    veto_time: Optional[int]
    curse_time: Optional[int]

    def parse(source: dict):
        return Challenge(
            coins=int(source.pop("coins")),
            veto_time=(retrieved := source.pop("veto_time", None)) and int(retrieved),
            curse_time=(retrieved := source.pop("curse_time", None)) and int(retrieved),
            **source,
        )


def load_challenges() -> Iterable[Challenge]:
    as_text = CHALLENGES_PATH.read_text()
    as_dict_list = json.loads(as_text)["challenges"]

    return map(Challenge.parse, as_dict_list)


def write_as_tsv(where_to, challenges: Iterable[Challenge]):
    writer = csv.writer(where_to, delimiter="\t")
    writer.writerow(["Header", "Coins", "Veto Time", "Curse Time", "Description"])

    for challenge in challenges:
        writer.writerow(
            [
                challenge.header,
                challenge.coins,
                challenge.veto_time,
                challenge.curse_time,
                challenge.text,
            ]
        )


def parse_args():
    parser = argparse.ArgumentParser(
        description="converts the challenges from JSON into TSV (help this is overkill)"
    )
    parser.add_argument("output_path")
    return parser.parse_args()


def main():
    args = parse_args()

    challenges = load_challenges()
    with open(args.output_path, "w") as fh:
        write_as_tsv(fh, challenges)


if __name__ == "__main__":
    main()
