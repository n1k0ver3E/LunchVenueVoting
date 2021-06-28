# LunchVenueVoting

## 0x00 Introduction

This is my first solidity project, LunchVenue Voting. The spec can be found at [here](https://github.com/PYF0311/LunchVenueVoting/blob/main/COMP_6452_Project_1%202021.pdf).

**Solidity Version**: ``^0.8.0``

```
├── README.md
├── contracts
│   ├── LunchVenue.sol
│   ├── LunchVenue_updated.sol
│   └── artifacts
│       ├── LunchVenue.json
│       └── LunchVenue_metadata.json
└── tests
    ├── LunchVenue_test.sol
    └── LunchVenue_updated_test.sol
```

In `contracts` folder, ``LunchVenue.sol`` is to implement the basic function. ``LunchVenue_updated.sol`` is to meet the improvement requirements in spec.

In `tests` folder, `LunchVenue_test.sol`  is used to test `LunchVenue.sol`，`LunchVenue_updated_test.sol` is used to test `LunchVenue_updated.sol`.

## 0x01 Function Implementation

- Usage of Structure
- Add user / lunch venue
- When an accident occurs, the destruction contract
- Voting Timeout using block number

## 0x02 Deploy and test

### 1. git clone it

```
git clone git@github.com:PYF0311/LunchVenueVoting.git
```

### 2. Open in Remix

- Click `Connect to Localhost`

- Move to cloned folder, type

  ```
  remixd -s <absolute_folder_path> --remix-ide "<remix-ide-instance-URL>"
  ```

### 3. More detail can be found at spec



