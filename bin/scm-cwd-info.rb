#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# Based off of the work of Ben Hoskings:
#   https://github.com/benhoskings/dot-files/blob/master/files/bin/git_cwd_info
# And Geoffrey Grosenbach 
#   https://raw.github.com/topfunky/zsh-simple/master/bin/git-cwd-info.rb
#   
# Author: Ted Naleid 
#
# I've added mercurial metadata output to the work done by the above authors to add git metadata
# This script emits output that can be used as part of a zsh prompt

# The methods that get called more than once are memoized.

# git commands

def git_repo_path
  @git_repo_path ||= `git rev-parse --git-dir 2>/dev/null`.strip
  # @git_repo_path
end

def in_git_repo
  !git_repo_path.empty? &&
  git_repo_path != '~' &&
  git_repo_path != "#{ENV['HOME']}/.git"
end

def git_parse_branch
  @git_parse_branch ||= `$ZSHDIR/bin/git-current-branch`.chomp
end

def git_head_commit_id
  `git rev-parse --short HEAD 2>/dev/null`.strip
end

def git_cwd_dirty
  # to match mercurial, add a "+" to the rev number if the working directory is dirty
  "+%{\e[0m%}" unless git_repo_path == '.' || `git ls-files -m`.strip.empty?
end

def rebasing_etc
  if File.exists?(File.join(git_repo_path, 'BISECT_LOG'))
    "_bisect"
  elsif File.exists?(File.join(git_repo_path, 'MERGE_HEAD'))
    "_merge"
  elsif %w[rebase rebase-apply rebase-merge ../.dotest].any? {|d| File.exists?(File.join(git_repo_path, d)) }
    "_rebase"
  end
end

# mercurial commands

def hg_identify
  @hg_identify ||= `hg identify -bn 2>/dev/null`.strip
end

def in_hg_repo
  !hg_identify.empty? 
end

def hg_parse_branch
  @hg_parse_branch ||= hg_identify.split(" ").last
end

def hg_head_commit_id
  # the friendly repo number, change to -i for the hash id
  @hg_head_commit_id ||= hg_identify.split(" ").first
end

if in_git_repo
  print " %{\e[90m%}#{git_parse_branch} %{\e[37m%}#{git_head_commit_id}#{git_cwd_dirty}%{\e[0m%}#{rebasing_etc}"
end

if in_hg_repo
  # don't need dirty in hg as it's already taken care of by the identify command with a + on the rev if dirty
  print " %{\e[90m%}#{hg_parse_branch} %{\e[37m%}#{hg_head_commit_id}%{\e[0m%}" 
end 
