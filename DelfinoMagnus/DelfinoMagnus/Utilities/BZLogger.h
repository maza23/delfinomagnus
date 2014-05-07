//
//  BZLogger.h
//  Buzz
//
//  Created by Avadesh Kumar on 28/03/13.
//  Copyright (c) 2013 Telibrahma. All rights reserved.
//

#ifndef Buzz_BZLogger_h
#define Buzz_BZLogger_h


#ifndef LOGGING_ENABLED
#	define LOGGING_ENABLED		1
#endif

#ifndef LOGGING_LEVEL_TRACE             //LogTrace
#	define LOGGING_LEVEL_TRACE		1
#endif
#ifndef LOGGING_LEVEL_INFO             //LogInfo
#	define LOGGING_LEVEL_INFO		1
#endif
#ifndef LOGGING_LEVEL_ERROR             //LogError
#	define LOGGING_LEVEL_ERROR		1
#endif
#ifndef LOGGING_LEVEL_DEBUG             //LogDebug
#	define LOGGING_LEVEL_DEBUG		0
#endif

#ifndef LOGGING_INCLUDE_CODE_LOCATION
#define LOGGING_INCLUDE_CODE_LOCATION	0
#endif

// *********** END OF USER SETTINGS  - Do not change anything below this line ***********

#if !(defined(LOGGING_ENABLED) && LOGGING_ENABLED)
#undef LOGGING_LEVEL_TRACE
#undef LOGGING_LEVEL_INFO
#undef LOGGING_LEVEL_ERROR
#undef LOGGING_LEVEL_DEBUG
#endif

// Logging format
#define LOG_FORMAT_NO_LOCATION(fmt, lvl, ...) NSLog((@"[%@] " fmt), lvl, ##__VA_ARGS__)
#define LOG_FORMAT_WITH_LOCATION(fmt, lvl, ...) NSLog((@"%s[Line %d] [%@] " fmt), __PRETTY_FUNCTION__, __LINE__, lvl, ##__VA_ARGS__)

#if defined(LOGGING_INCLUDE_CODE_LOCATION) && LOGGING_INCLUDE_CODE_LOCATION
#define LOG_FORMAT(fmt, lvl, ...) LOG_FORMAT_WITH_LOCATION(fmt, lvl, ##__VA_ARGS__)
#else
#define LOG_FORMAT(fmt, lvl, ...) LOG_FORMAT_NO_LOCATION(fmt, lvl, ##__VA_ARGS__)
#endif

// Trace logging - for detailed tracing
#if defined(LOGGING_LEVEL_TRACE) && LOGGING_LEVEL_TRACE
#define LogTrace(fmt, ...) LOG_FORMAT(fmt, @"TRACE", ##__VA_ARGS__)
#else
#define LogTrace(...)
#endif

// Info logging - for general, non-performance affecting information messages
#if defined(LOGGING_LEVEL_INFO) && LOGGING_LEVEL_INFO
#define LogInfo(fmt, ...) LOG_FORMAT(fmt, @"INFO", ##__VA_ARGS__)
#else
#define LogInfo(...)
#endif

// Error logging - only when there is an error to be logged
#if defined(LOGGING_LEVEL_ERROR) && LOGGING_LEVEL_ERROR
#define LogError(fmt, ...) LOG_FORMAT(fmt, @"***ERROR***", ##__VA_ARGS__)
#else
#define LogError(...)
#endif

// Debug logging - use only temporarily for highlighting and tracking down problems
#if defined(LOGGING_LEVEL_DEBUG) && LOGGING_LEVEL_DEBUG
#define LogDebug(fmt, ...) LOG_FORMAT(fmt, @"DEBUG", ##__VA_ARGS__)
#else
#define LogDebug(...)
#endif


#endif //Buzz_BZLogger_h
