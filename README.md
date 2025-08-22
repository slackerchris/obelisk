# D&D Initiative Tracker - Fantasy Obelisk Design

This repository contains OpenSCAD code for creating functional D&D initiative trackers in the form of fantasy obelisks. Perfect for tabletop RPG sessions!

## 🎲 What This Is

A **3D-printable initiative tracker** that helps manage turn order in D&D and other tabletop RPGs. The obelisk design adds thematic flair to your gaming table while providing practical functionality.

## 📁 Files

### Initiative Tracker Versions

### 1. `simple_initiative_tower.scad` - **Recommended for Most Users**
Easy-to-print, practical design:
- **6 initiative slots** with sliding tokens
- **Round counter** at the top
- **Storage compartment** in base for dice/tokens
- **Color-coded tokens** (Player/Enemy/NPC/Neutral)
- **No supports needed** for printing

### 2. `dnd_initiative_tracker.scad` - Advanced Version
Full-featured tracker with:
- **8 initiative slots** with mounting system
- **Card holders** for initiative cards or name tags
- **Enhanced storage** compartment
- **Round tracking** system
- **Detailed symbols** for each participant type

### 3. `modular_initiative_tracker.scad` - Customizable System
Print components separately:
- **Modular design** - print only what you need
- **Multiple slot types** in different colors
- **Separate storage tray**
- **Expandable** - print more slots as needed

### Original Fantasy Versions
### 4. `fantasy_obelisk.scad` - Decorative Original
The original fantasy obelisk that inspired the initiative tracker

### 5. `enhanced_obelisk.scad` - Detailed Decorative Version  
Enhanced decorative version with better texturing

### 6. `modular_obelisk.scad` - Customizable Decorative Version
Highly modular decorative system

## 🎮 How It Works

### Initiative Tracking
1. **Roll initiative** for all players, NPCs, and enemies
2. **Select appropriate tokens** by type:
   - 🟢 **Green** = Player Characters
   - 🔴 **Red** = Enemies/Monsters  
   - 🔵 **Blue** = NPCs
   - 🟤 **Tan** = Neutral/Environmental
3. **Insert tokens** in initiative order (highest at top)
4. **Work down** the tower each round
5. **Track rounds** with the rotating counter at top

### Token Features
- **Card slots** for initiative cards or name tags
- **Type symbols** to quickly identify participant types
- **Initiative numbers** (optional) for easy reference
- **Sliding design** - easily rearrange during combat

## 🖨️ 3D Printing Guide

### Recommended Print Settings
- **Layer Height:** 0.2mm
- **Infill:** 15-20%
- **Supports:** Not needed for recommended designs
- **Print Speed:** Normal (50mm/s)

### Print Order
1. **Main Tower** (print upright)
2. **Token Set** (print flat, 8 tokens per set)
3. **Round Tracker** (print flat)

### Multi-Color Printing
- Print tokens in different colors for easy identification
- Or use single color and paint/mark after printing

## ⚙️ Customization

### Simple Version Parameters
```scad
TOWER_HEIGHT = 80;           // Adjust for your table
SLOT_COUNT = 6;              // Number of initiative slots
SLOT_WIDTH = 12;             // Token width
BASE_SIZE = 25;              // Base diameter
```

### Token Types
The system includes symbols for:
- **Player Characters** (person silhouette)
- **Enemies** (skull/claw symbols)
- **NPCs** (house symbol)
- **Neutral** (diamond symbol)

## 📏 Sizing for Your Table

### Standard Tabletop
- **Height:** 80mm (good visibility, not too tall)
- **Base:** 25mm diameter (stable, doesn't take much space)

### Large Table / Convention Use
- **Height:** 120mm (visible from further away)
- **Base:** 35mm diameter (extra stability)

### Compact/Travel Version
- **Height:** 60mm (fits in smaller bags)
- **Base:** 20mm diameter (minimal table footprint)

## 🎯 Usage Tips

### Session Prep
1. **Print extra tokens** of each type for large encounters
2. **Number tokens** 1-20 for easy reference
3. **Test fit** initiative cards if using card slots

### During Play
- **Top-down order** - highest initiative at top
- **Visual clarity** - different colors help players track their turn
- **Quick setup** - just slide tokens into slots
- **Round tracking** - rotate the top ring to mark rounds

### Storage
- **Tokens stack** inside the base storage compartment
- **Dice storage** in base hollow
- **Compact** when disassembled

## 🔄 Variants & Modifications

### Easy Modifications
- **Scale everything** by changing the scale factor
- **Add more slots** by increasing `SLOT_COUNT`
- **Resize for mini cards** by adjusting slot dimensions
- **Add custom symbols** by modifying the symbol modules

### Advanced Customizations
- **LED integration** for the "crystal" top
- **Magnetic tokens** for extra security
- **Custom base shapes** (hexagonal, square, etc.)
- **Modular height** sections for different encounter sizes