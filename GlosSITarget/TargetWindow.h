/*
Copyright 2021 Peter Repukat - FlatspotSoftware

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
#pragma once
#include <functional>

#include <SFML/Graphics/RenderWindow.hpp>

class TargetWindow {
  public:
    explicit TargetWindow(std::function<void()> on_close = []() {});

    void setFpsLimit(unsigned int fps_limit);
    void setClickThrough(bool click_through);
    void update();
    void close();

  private:
    const std::function<void()> on_close_;
    sf::RenderWindow window_;

};
