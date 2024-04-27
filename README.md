# 说明

## 操作

- 鼠标左键：切换是否记录轨迹
- 鼠标右键：切换Camera是否绑定玩家模型
- 中键拖拽：在Camera不绑定模型时转动模型
- WASD：移动Camera
- IJKL：移动模型
- 上下左右：让鼠标移动一个点
- R：清除轨迹
- Y：切换是否记录每帧间的轨迹
- H：回到原点

## 参数

- main.gd:
    ```
    Engine.max_fps = 240 # 最大帧数，0无限制
    ```
    
- Player.gd:
    ```
    var trace_length = 500 # 轨迹点数
    ```

- Observer.gd:
    ```
    var sensitivity = 1 # Camera灵敏度
    ```

- PlayerModel.gd:
    ```
    var sensitivity = 1 # 单独转动玩家模型的灵敏度
    ```
