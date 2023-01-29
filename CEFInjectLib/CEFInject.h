/*
Copyright 2021-2023 Peter Repukat - FlatspotSoftware

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

#include <httplib.h>
#include <nlohmann/json.hpp>


namespace CEFInject
{
	namespace internal {
		httplib::Client GetHttpClient(uint16_t port);
	}

	bool CEFDebugAvailable(uint16_t port = 8080);
	std::vector<std::wstring> AvailableTabs(uint16_t port = 8080);
	std::string InjectJs(const std::wstring& tabname, const std::wstring& js, uint16_t port = 8080);

}