# Scrawl Language Feature Reference

This document outlines all features of the Scrawl markup language with examples for visual testing. Open the corresponding `.scrawl` test file in your editor to verify syntax highlighting.

---

## Table of Contents

1. [Comments](#1-comments)
2. [Section Tags](#2-section-tags)
3. [Task States](#3-task-states)
4. [Priority Levels](#4-priority-levels)
5. [Indent Levels](#5-indent-levels)
6. [List Styles](#6-list-styles)
7. [Date Tokens](#7-date-tokens)
8. [Time Estimates](#8-time-estimates)
9. [Quick Tags](#9-quick-tags)
10. [Hashtags](#10-hashtags)
11. [Progress Bars](#11-progress-bars)
12. [Percentages](#12-percentages)
13. [URLs](#13-urls)
14. [Code Blocks](#14-code-blocks)

---

## 1. Comments

### Line Comments
Single-line comments starting with `//`.

**Syntax:** `// comment text`

**Example:**
```
// This is a line comment
// TODO: Remember to update this
```

**Scope:** `comment.line.scrawl`

---

### Block Comments
Multi-line comments wrapped in `/* */`.

**Syntax:**
```
/*
Comment text
spans multiple lines
*/
```

**Example:**
```
/*
This is a block comment
that spans multiple lines
*/
```

**Scope:** `comment.block.scrawl`

---

### Date Header (Special Block Comment)
Decorative header format for daily notes.

**Syntax:**
```
/*
*-----------------------------------------
* ///////////
* MM/DD/YYYY DayName
* ///////////
*-----------------------------------------
*/
```

**Example:**
```
/*
*-----------------------------------------
* ///////////
* 11/30/2025 Saturday
* ///////////
*-----------------------------------------
*/
```

**Scope:** `comment.block.scrawl markup.heading.note-header.scrawl`

---

## 2. Section Tags

Foldable section markers for organizing content.

**Syntax:** `##SectionName##`

**Example:**
```
##Project Setup##

Content goes here...

##End##
```

**Scope:** `markup.bold.tag.scrawl entity.name.section.folding.scrawl`

---

## 3. Task States

Nine different task states to track work status.

| State | Symbol | Meaning |
|-------|--------|---------|
| Unchecked | `[ ]` | Pending/not started |
| In Progress | `[•]` | Currently working on |
| Completed (check) | `[√]` | Done (checkmark) |
| Completed (x) | `[x]` | Done (x mark) |
| Urgent | `[!]` | Needs immediate attention |
| Skipped | `[-]` | Decided not to do |
| On Hold | `[.]` | Paused/waiting |
| Added | `[+]` | Newly added item |
| Question | `[?]` | Needs clarification |

**Examples:**
```
[ ] Unchecked task - pending work
[•] In progress task - actively working
[√] Completed task - finished with checkmark
[x] Completed task - finished with x
[!] Urgent task - needs attention now
[-] Skipped task - decided not to do
[.] On hold task - paused for now
[+] Added task - newly added to list
[?] Question task - needs clarification
```

**Scopes:**
- `markup.list.task.unchecked.level0.scrawl`
- `markup.list.task.inprogress.level0.scrawl`
- `markup.list.task.completed.level0.scrawl`
- `markup.list.task.urgent.level0.scrawl`
- `markup.list.task.skipped.level0.scrawl`
- `markup.list.task.onhold.level0.scrawl`
- `markup.list.task.added.level0.scrawl`
- `markup.list.task.question.level0.scrawl`

---

## 4. Priority Levels

Four priority levels for urgent tasks.

| Priority | Symbol | Meaning |
|----------|--------|---------|
| Critical | `[!0]` | Drop everything |
| High | `[!1]` | Do soon |
| Medium | `[!2]` | Normal importance |
| Low | `[!3]` | When time permits |

**Examples:**
```
[!0] Critical priority - drop everything
[!1] High priority - do soon
[!2] Medium priority - normal importance
[!3] Lower priority - when time permits
```

**Scope:** `constant.numeric.priority.scrawl`

---

## 5. Indent Levels

Tasks and lists support 4 indent levels (0, 4, 8, 12+ spaces).

**Examples:**
```
[ ] Level 0 - no indent
    [ ] Level 1 - 4 spaces
        [ ] Level 2 - 8 spaces
            [ ] Level 3+ - 12+ spaces
```

**Scopes:**
- Level 0: `markup.list.task.*.level0.scrawl`
- Level 1: `markup.list.task.*.level1.scrawl`
- Level 2: `markup.list.task.*.level2.scrawl`
- Level 3+: `markup.list.task.*.level3.scrawl`

---

## 6. List Styles

Six different list marker styles.

### Dash Lists
**Syntax:** `- item`

```
- Dash list item
- Another item
    - Nested item
        - Deep nested
```

**Scope:** `markup.list.unnumbered.dash.scrawl`

---

### Arrow Lists
**Syntax:** `-> item`

```
-> Arrow shows flow
-> Next step
    -> Sub-step
        -> Detail
```

**Scope:** `markup.list.unnumbered.arrow.scrawl`

---

### Thick Arrow Lists
**Syntax:** `=> item`

```
=> Emphasis point
=> Important item
    => Sub-point
        => Detail
```

**Scope:** `markup.list.unnumbered.thickarrow.scrawl`

---

### Asterisk Lists
**Syntax:** `* item`

```
* Asterisk item
* Another item
    * Nested
        * Deep nested
```

**Scope:** `markup.list.unnumbered.asterisk.scrawl`

---

### Bullet Lists
**Syntax:** `• item`

```
• Bullet item
• Another item
    • Nested
        • Deep nested
```

**Scope:** `markup.list.unnumbered.bullet.scrawl`

---

### Numbered Lists
**Syntax:** `1. item` or `1.1. item`

```
1. First item
2. Second item
3. Third item
    1. Nested first
    2. Nested second
        1. Deep nested

1.1. Sub-numbered item
1.2. Another sub-item
1.2.1. Triple sub-numbered
```

**Scopes:**
- `markup.list.numbered.scrawl`
- `markup.list.numbered.sub.scrawl`

---

## 7. Date Tokens

Date markers for deadlines and scheduling.

**Syntax:** `d@DATE` or `d@DATE TIME`

### ISO Format (YYYY-MM-DD)
```
[ ] Task due d@2025-12-15
[ ] Meeting d@2025-12-20 14:30
[ ] Deadline d@2025-12-10 09:00
```

### US Format (MM/DD/YYYY)
```
[ ] Task due d@12/15/2025
[ ] Meeting d@12/20/2025 2:30 PM
[ ] Morning task d@12/01/2025 9 AM
```

**Scopes:**
- `keyword.operator.date-marker.scrawl` (d@)
- `constant.other.date.scrawl` (date value)
- `constant.other.time.scrawl` (time value)

---

## 8. Time Estimates

Effort estimation markers.

**Syntax:** `e@TIME`

| Format | Example | Meaning |
|--------|---------|---------|
| Minutes | `e@30m` | 30 minutes |
| Hours | `e@2h` | 2 hours |
| Combined | `e@4h30m` | 4 hours 30 minutes |

**Examples:**
```
[ ] Quick fix e@15m
[ ] Medium task e@2h
[ ] Long feature e@4h30m
[ ] Documentation e@45m
```

**Scopes:**
- `keyword.operator.time-marker.scrawl` (e@)
- `constant.numeric.time-estimate.hours.scrawl` (hours)
- `constant.numeric.time-estimate.minutes.scrawl` (minutes)

---

## 9. Quick Tags

Mention people, teams, or resources.

**Syntax:** `@tag-name`

**Examples:**
```
[ ] Ask @john-smith about design
[ ] Deploy to @production
[ ] Review with @team-lead
[ ] Check @security-review
```

**Scopes:**
- `punctuation.definition.tag.quick.scrawl` (@)
- `entity.name.tag.quick.scrawl` (tag name)

---

## 10. Hashtags

Categorization and topic tags.

**Syntax:** `#tag-name`

**Examples:**
```
[ ] Review docs #urgent #technical
[ ] Feature work #development #frontend
[ ] API changes #api #database
[ ] Critical bug #bug #production
```

**Scopes:**
- `punctuation.definition.tag.hashtag.scrawl` (#)
- `entity.name.tag.hashtag.scrawl` (tag name)

---

## 11. Progress Bars

Visual progress indicators.

**Syntax:** `[==>       ]` (= for filled, > for current, spaces for remaining)

**Examples:**
```
[          ] 0% - Not started
[==>       ] 25% - Quarter done
[=====>    ] 50% - Halfway
[=======>  ] 75% - Almost there
[==========] 100% - Complete
```

**Scope:** `markup.other.progress-bar.scrawl`

---

## 12. Percentages

Numeric progress values.

**Syntax:** `NN%`

**Examples:**
```
[ ] Task progress 0%
[•] In progress 45%
[•] Nearly done 90%
[√] Complete 100%
```

**Scope:** `constant.numeric.percentage.scrawl`

---

## 13. URLs

Automatic URL detection and highlighting.

**Syntax:** `https://...` or `www....`

**Examples:**
```
Check https://example.com for info
See www.github.com/project
Visit https://docs.example.com/api/v2
```

**Scope:** `markup.underline.link.url.scrawl`

---

## 14. Code Blocks

Fenced code blocks with language-specific syntax highlighting.

**Syntax:**
~~~
```language
code here
```
~~~

### Supported Languages

| Language | Aliases |
|----------|---------|
| TypeScript | `typescript`, `ts` |
| JavaScript | `javascript`, `js` |
| Python | `python`, `py` |
| Ruby | `ruby`, `rb` |
| C | `c` |
| C++ | `c++`, `cpp`, `cxx` |
| C# | `c#`, `csharp`, `cs` |
| Java | `java` |
| HTML | `html`, `htm` |
| CSS | `css` |
| SCSS | `scss` |
| SASS | `sass` |
| LESS | `less` |
| PHP | `php` |
| Go | `go` |
| Rust | `rust` |
| Bash | `bash`, `sh`, `shell`, `zsh` |
| SQL | `sql` |
| JSON | `json` |
| XML | `xml` |
| YAML | `yaml`, `yml` |
| Markdown | `markdown`, `md` |

Any other language identifier still produces a fenced raw block (monospace,
no language-specific coloring), so unsupported fences degrade gracefully.

**Examples:**

~~~
```typescript
interface Task {
  id: string;
  title: string;
  status: 'pending' | 'completed';
}
```
~~~

~~~
```python
def process_task(task: dict) -> bool:
    return task.get('status') == 'completed'
```
~~~

~~~
```bash
#!/bin/bash
npm install
npm run build
```
~~~

**Scope:** `markup.raw.block.markdown` + embedded language scope

---

## Combined Examples

Tasks with multiple inline elements:

```
[ ] Review PR from @john-smith d@2025-12-15 e@1h #code-review
[•] Fix bug in @api-gateway d@2025-12-10 e@4h #urgent #backend [====>     ] 45%
[!0] Critical issue @ops-team d@2025-12-01 e@2h #incident #p0
```

Nested structure with mixed elements:

```
##Sprint Tasks##

1. Project setup
    [ ] Initialize repository d@2025-12-01
    [ ] Configure CI/CD e@2h #devops
    [•] Setup dev environment [===>      ] 35%

2. Feature development
    -> Plan architecture #planning
    -> Backend implementation @backend-team e@8h
        [ ] Create API endpoints
        [•] Database schema
    -> Frontend integration @frontend-team

##End##
```

---

## Visual Testing Checklist

When testing in your editor, verify:

- [ ] Comments appear in comment color (gray/muted)
- [ ] Section tags are bold/highlighted
- [ ] Each task state has distinct styling
- [ ] Priority numbers are highlighted
- [ ] Indent levels maintain consistent coloring
- [ ] List markers are styled appropriately
- [ ] `d@` dates show date-specific coloring
- [ ] `e@` estimates show time-specific coloring
- [ ] `@tags` are highlighted (mention style)
- [ ] `#hashtags` are highlighted (tag style)
- [ ] Progress bars have distinct styling
- [ ] Percentages show numeric styling
- [ ] URLs are underlined/linked
- [ ] Code blocks show language-specific highlighting
