/** @jsx React.createElement */
import React, { useState, useEffect } from "react";
import { ActionPanel, Action, List, showToast, Toast, getPreferenceValues, Icon } from "@raycast/api";

interface RedditPost {
  id: string;
  title: string;
  score: number;
  num_comments: number;
  subreddit: string;
  permalink: string;
  url: string;
}

interface Preferences {
  subreddit: string;
  timeRange: string;
}

// Predefined subreddit options
const SUBREDDIT_OPTIONS = [
  { title: "LandscapePhotography", value: "LandscapePhotography" },
  { title: "Popular (All Reddit)", value: "popular" },
  { title: "Custom", value: "custom" }
];

// Time range options
const TIME_RANGE_OPTIONS = [
  { title: "Today", value: "day" },
  { title: "This Week", value: "week" },
  { title: "This Month", value: "month" },
  { title: "This Year", value: "year" },
  { title: "All Time", value: "all" }
];

export default function Command() {
  const preferences = getPreferenceValues<Preferences>();
  const defaultSubreddit = preferences.subreddit || "LandscapePhotography";
  const defaultTimeRange = preferences.timeRange || "day";
  
  const [isLoading, setIsLoading] = useState(true);
  const [posts, setPosts] = useState<RedditPost[]>([]);
  const [error, setError] = useState<Error | undefined>();
  const [timeRange, setTimeRange] = useState(defaultTimeRange);
  const [customSubreddit, setCustomSubreddit] = useState("");
  const [selectedSubredditOption, setSelectedSubredditOption] = useState(
    SUBREDDIT_OPTIONS.some(opt => opt.value === defaultSubreddit) 
      ? defaultSubreddit 
      : "custom"
  );
  const [searchText, setSearchText] = useState("");
  
  // Function to load posts from a specific subreddit
  async function fetchSubredditPosts(subreddit: string, timeFrame: string) {
    if (!subreddit) return;
    
    setIsLoading(true);
    setError(undefined);
    
    try {
      const url = `https://www.reddit.com/r/${subreddit}/top/.json?t=${timeFrame}&limit=25`;
      // Add a user agent to avoid 429 errors
      const response = await fetch(url, {
        headers: {
          "User-Agent": "Raycast Reddit Trends Extension"
        }
      });
      
      if (!response.ok) {
        throw new Error(`Error ${response.status}: ${response.statusText}`);
      }
      
      const data = await response.json() as any;
      
      if (!data.data?.children?.length) {
        throw new Error(`No posts found for r/${subreddit}`);
      }
      
      const redditPosts = data.data.children.map((child: any) => {
        const post = child.data;
        return {
          id: post.id,
          title: post.title,
          score: post.score,
          num_comments: post.num_comments,
          subreddit: post.subreddit,
          permalink: post.permalink,
          url: post.url,
        };
      });
      
      setPosts(redditPosts);
    } catch (error) {
      console.error(error);
      setError(error instanceof Error ? error : new Error("Something went wrong"));
      setPosts([]); // Clear posts on error
    } finally {
      setIsLoading(false);
    }
  }

  // When subreddit option changes
  useEffect(() => {
    if (selectedSubredditOption !== "custom") {
      fetchSubredditPosts(selectedSubredditOption, timeRange);
    } else if (customSubreddit) {
      fetchSubredditPosts(customSubreddit, timeRange);
    } else {
      setIsLoading(false);
    }
  }, [selectedSubredditOption, customSubreddit, timeRange]);

  useEffect(() => {
    if (error) {
      showToast({
        style: Toast.Style.Failure,
        title: "Failed to load Reddit posts",
        message: error.message,
      });
    }
  }, [error]);

  function handleSearchTextChange(text: string) {
    if (selectedSubredditOption === "custom") {
      setCustomSubreddit(text);
    } else {
      setSearchText(text);
    }
  }

  // The displayed subreddit name
  const displayedSubreddit = selectedSubredditOption === "custom" ? customSubreddit : selectedSubredditOption;
  
  // Get current time range title
  const currentTimeRangeTitle = TIME_RANGE_OPTIONS.find(option => option.value === timeRange)?.title || "Today";
  
  // Get current subreddit option title
  const currentSubredditTitle = selectedSubredditOption === "custom" 
    ? (customSubreddit ? `r/${customSubreddit}` : "Enter a subreddit name")
    : SUBREDDIT_OPTIONS.find(option => option.value === selectedSubredditOption)?.title || "";

  // Filter posts if there is search text
  const filteredPosts = searchText && selectedSubredditOption !== "custom"
    ? posts.filter((post: RedditPost) => post.title.toLowerCase().includes(searchText.toLowerCase()))
    : posts;

  return (
    <List 
      isLoading={isLoading}
      searchBarPlaceholder={selectedSubredditOption === "custom" 
        ? "Enter custom subreddit name..." 
        : "Search within posts..."
      }
      onSearchTextChange={handleSearchTextChange}
      searchText={selectedSubredditOption === "custom" ? customSubreddit : searchText}
      onSubmit={text => {
        if (selectedSubredditOption === "custom" && text) {
          setCustomSubreddit(text);
        }
      }}
      navigationTitle={`Reddit Trends: r/${displayedSubreddit}`}
    >
      <List.Section title="Settings">
        <List.Item
          title="Subreddit"
          subtitle={currentSubredditTitle}
          accessories={[{ text: "Change" }]}
          actions={
            <ActionPanel>
              <ActionPanel.Section title="Select Subreddit">
                {SUBREDDIT_OPTIONS.map(option => (
                  <Action
                    key={option.value}
                    title={option.title}
                    onAction={() => {
                      setSelectedSubredditOption(option.value);
                      if (option.value !== "custom") {
                        setSearchText("");
                      }
                    }}
                  />
                ))}
              </ActionPanel.Section>
            </ActionPanel>
          }
        />
        
        <List.Item
          title="Time Range"
          subtitle={currentTimeRangeTitle}
          accessories={[{ text: "Change" }]}
          actions={
            <ActionPanel>
              <ActionPanel.Section title="Select Time Range">
                {TIME_RANGE_OPTIONS.map(option => (
                  <Action
                    key={option.value}
                    title={option.title}
                    onAction={() => setTimeRange(option.value)}
                  />
                ))}
              </ActionPanel.Section>
            </ActionPanel>
          }
        />
      </List.Section>

      {filteredPosts.length > 0 && (
        <List.Section title={`Trending on r/${displayedSubreddit}`}>
          {filteredPosts.map((post: RedditPost) => (
            <List.Item
              key={post.id}
              title={post.title}
              subtitle={`r/${post.subreddit}`}
              accessories={[
                { text: `↑ ${formatNumber(post.score)}` },
                { text: `💬 ${formatNumber(post.num_comments)}` }
              ]}
              actions={
                <ActionPanel>
                  <Action.OpenInBrowser url={`https://reddit.com${post.permalink}`} title="Open Post" />
                  <Action.OpenInBrowser url={post.url} title="Open Content URL" />
                  <Action.CopyToClipboard content={`https://reddit.com${post.permalink}`} title="Copy Link" />
                </ActionPanel>
              }
            />
          ))}
        </List.Section>
      )}

      {!isLoading && filteredPosts.length === 0 && !(selectedSubredditOption === "custom" && !customSubreddit) && (
        <List.EmptyView
          title={
            error 
              ? `Error loading r/${displayedSubreddit}` 
              : `No posts found for r/${displayedSubreddit}`
          }
          description={error ? error.message : "Try changing the subreddit or time range"}
        />
      )}
    </List>
  );
}

function formatNumber(num: number): string {
  if (num >= 1000000) {
    return (num / 1000000).toFixed(1) + 'm';
  } else if (num >= 1000) {
    return (num / 1000).toFixed(1) + 'k';
  }
  return num.toString();
}
